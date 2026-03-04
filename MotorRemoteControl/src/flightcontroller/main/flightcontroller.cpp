#include <stdio.h>
#include <string.h>
#include <errno.h>
#include "sdkconfig.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_wifi.h"
#include "esp_event.h"
#include "nvs_flash.h"
#include "lwip/sockets.h"
#include "driver/mcpwm_prelude.h"
#include "secrets.h"
#include "esp_task_wdt.h"
#include "driver/mcpwm_prelude.h"
#include "esp_timer.h"


mcpwm_cmpr_handle_t comparator_handle = NULL; // value determines pwm on/off intervall
int sock = -1;
struct __attribute__((__packed__)) ControllerData { //Object/data container to receive
    uint8_t speed;                      
};


static void event_handler(void* arg, esp_event_base_t event_base, int32_t event_id, void* event_data){ //handle connect/disconnect events, called repeatedly if it cant connect
    if(event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_START){
        esp_wifi_connect();
    }
    else if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_DISCONNECTED){
        printf("Connection lost, retrying.");
        esp_wifi_connect();
    }
    else if(event_base == IP_EVENT && event_id == IP_EVENT_STA_GOT_IP){
        printf("Connected succesfully.");
    }

}


void init_wifi(){
    esp_err_t nvs_fb = nvs_flash_init(); //activate nvs flash memory
    if(nvs_fb == ESP_ERR_NVS_NO_FREE_PAGES || nvs_fb == ESP_ERR_NVS_NEW_VERSION_FOUND){ //memory full or version dismatch -> retry
        ESP_ERROR_CHECK(nvs_flash_erase()); //ESP_ERROR_CHECK: Macro -> if ESP_OK continue else reboot
        vTaskDelay(pdMS_TO_TICKS(1000));
        nvs_fb = nvs_flash_init();
    }
    ESP_ERROR_CHECK(nvs_fb); //still cant start, maybe hardware problem -> reboot else continue
    
    ESP_ERROR_CHECK(esp_netif_init()); //start LwIP TCP/IP-stack
    ESP_ERROR_CHECK(esp_event_loop_create_default()); //loop for system messages, reserves memory space for messages and starts background task
    
    esp_netif_t* wifi_sta = esp_netif_create_default_wifi_sta(); //pointer auf station/client
    if(wifi_sta == NULL){
        printf("Critical ERROR. Restart");
        vTaskDelay(pdMS_TO_TICKS(2000));
        esp_restart();
    }
    wifi_init_config_t config = WIFI_INIT_CONFIG_DEFAULT(); //get standard config
    esp_event_handler_instance_t instance_id;
    ESP_ERROR_CHECK(esp_wifi_init(&config)); //load driver
    ESP_ERROR_CHECK(esp_event_handler_instance_register(WIFI_EVENT, ESP_EVENT_ANY_ID, &event_handler, NULL, &instance_id));
    
    wifi_config_t wifi_config = {}; //config struct with ssid and pw
    strcpy((char*)wifi_config.sta.ssid, SSID);
    strcpy((char*)wifi_config.sta.password, PW);
    wifi_config.sta.threshold.authmode = WIFI_AUTH_WPA2_PSK; //authentication mode
    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_STA)); //connect as as station/client
    ESP_ERROR_CHECK(esp_wifi_set_config(WIFI_IF_STA, &wifi_config)); //load config into driver

    ESP_ERROR_CHECK(esp_wifi_start());
    esp_wifi_set_ps(WIFI_PS_NONE); 
    printf("Driver started succesfully.");

}


void init_udp(){
    sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_IP); //create socket interface to network, AF_INET -> IPv4, SOCK_DGRAM -> UDP, IPPROTO_IP -> standard udp
    struct sockaddr_in dest_addr; //spezielle C-struktur für ipv4(familie,port,ip)
    struct timeval tv;
    if (sock < 0){
        printf("ERROR. Could not create UPD socket");
        esp_restart();
    }
    dest_addr.sin_addr.s_addr = htonl(INADDR_ANY); //listen to broadcast (esp32 is little endian, netzwerk ist big endian. htonl reverses 32 bit / ip adresse
    dest_addr.sin_family = AF_INET; //AF_INET = ipv4
    dest_addr.sin_port = htons(4210); //Port, host to network short

    if(bind(sock, (struct sockaddr *)&dest_addr, sizeof(dest_addr)) < 0){ //bind sock to port
        printf("ERROR: %d\n", errno);
        close(sock);
        sock = -1;
        esp_restart();
    }
    tv.tv_sec = 0;
    tv.tv_usec = 100000; //100.000µs
    if (setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)) < 0){ //socket options, timeout after 100ms
        printf("ERROR! Setting socket timeout failed. Error: %d\n", errno);
        close(sock);
        sock = -1;
        esp_restart();
    }
    printf("UDP server launched");
}


bool receive(int sock, ControllerData& data){ //returns true if the data is valid/complete, false if nothing or partial data received
    
    struct sockaddr_in source_addr;
    socklen_t socklen = sizeof(source_addr);
    int len = recvfrom(sock, &data, sizeof(ControllerData), 0, (struct sockaddr *)&source_addr, &socklen); //write received data into struct "data" and save length of received data

    if (len < 0){ //nothing received or timeout
        return false;
    }
    if (len == sizeof(ControllerData)){ //received full data
        return true;
    }
    printf("ERROR, wrong package size.");
    return false;

}
void init_pwm(){
    mcpwm_timer_config_t timer_config = { //50Hz, 1000µs on = 0% motor power, 2000µs on = 100% motor power 
        .group_id = 0,
        .clk_src = MCPWM_TIMER_CLK_SRC_DEFAULT, //use default clock of mcpw
        .resolution_hz = 1000000, //1.000.000 ticks/s -> 1 tick = 1µs
        .count_mode = MCPWM_TIMER_COUNT_MODE_UP,
        .period_ticks = 20000, // 1s/50 = 20.000µs -> 50Hz (timer counts to 20.000 then resets to 0
        };
    mcpwm_timer_handle_t timer_handle = NULL;   
    ESP_ERROR_CHECK(mcpwm_new_timer(&timer_config, &timer_handle)); //create timer

    mcpwm_operator_config_t operator_config = {
        .group_id = 0,
    };
    mcpwm_oper_handle_t operator_handle = NULL;
    ESP_ERROR_CHECK(mcpwm_new_operator(&operator_config, &operator_handle)); //create pwm operator
    
    ESP_ERROR_CHECK(mcpwm_operator_connect_timer(operator_handle, timer_handle)); //links operator to timer

    mcpwm_comparator_config_t comparator_config = {
        .flags = {
            .update_cmp_on_tez = true,                   //update when timer at 0, minimize glitches
        }
    };

    ESP_ERROR_CHECK(mcpwm_new_comparator(operator_handle, &comparator_config, &comparator_handle)); //create comparator

    mcpwm_generator_config_t generator_config = {
        .gen_gpio_num = 4,                          //set PWM output to pin 4
    };
    mcpwm_gen_handle_t generator_handle = NULL;
    ESP_ERROR_CHECK(mcpwm_new_generator(operator_handle, &generator_config, &generator_handle)); //create generator

    ESP_ERROR_CHECK(mcpwm_generator_set_action_on_timer_event(generator_handle, //what to do at start
        MCPWM_GEN_TIMER_EVENT_ACTION(MCPWM_TIMER_DIRECTION_UP, MCPWM_TIMER_EVENT_EMPTY, MCPWM_GEN_ACTION_HIGH))); //count up, timer = 0 -> event, on event/timer = 0 -> pin high
    
    ESP_ERROR_CHECK(mcpwm_generator_set_action_on_compare_event(generator_handle, //what to do at compare event
        MCPWM_GEN_COMPARE_EVENT_ACTION(MCPWM_TIMER_DIRECTION_UP, comparator_handle, MCPWM_GEN_ACTION_LOW))); //set PIN to low when hitting compare

    ESP_ERROR_CHECK(mcpwm_timer_enable(timer_handle)); //activate timer
    ESP_ERROR_CHECK(mcpwm_timer_start_stop(timer_handle, MCPWM_TIMER_START_NO_STOP)); //activate timer
}

void set_speed(mcpwm_cmpr_handle_t comparator, uint8_t speed){
    uint32_t high_time = speed * 10 + 1000; //convert speed in % to ticks
    if ( high_time < 1000){
        high_time = 1000;
    }
    if (high_time > 1800){
        high_time = 1800;
    }
    ESP_ERROR_CHECK(mcpwm_comparator_set_compare_value(comparator, high_time)); //set new compare value -> on/off-time -> speed 
}


extern "C" void app_main(void)
{
    esp_task_wdt_config_t wdt_config = { //watchdog config
        .timeout_ms = 3000, //restart after 3000ms not fed
        .idle_core_mask = (1 << portNUM_PROCESSORS) - 1, //watches both cores
        .trigger_panic = true,
    };

    init_wifi();
    init_udp();
    init_pwm();
    ControllerData data;
    int64_t last_rec_time = esp_timer_get_time();


    ESP_ERROR_CHECK(esp_task_wdt_init(&wdt_config));
    ESP_ERROR_CHECK(esp_task_wdt_add(NULL)); //add main function to watchdog

    while(true){
        if (receive(sock, data)){
            set_speed(comparator_handle, data.speed);
            last_rec_time = esp_timer_get_time();
        }
        if(esp_timer_get_time() - last_rec_time > 1000000){ //1000000µs timeout after 1s no packet received
            set_speed(comparator_handle, 0);
        }
        ESP_ERROR_CHECK(esp_task_wdt_reset()); //feeding the dog
        printf("speed is now %d \n", data.speed);
        vTaskDelay(pdMS_TO_TICKS(10));
    }
   
}
