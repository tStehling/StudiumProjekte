#include <stdio.h>
#include "pico/stdlib.h"
#include <pico/cyw43_arch.h>
#include "lwip/pbuf.h"
#include "lwip/udp.h"
#include "secrets.h"
#include "hardware/watchdog.h"


const uint BUTTON_5LOWER = 0; //lower motor power by 5%
const uint BUTTON_5UPPER = 1; // raise motor power by 5%
const uint BUTTON_20LOWER = 2; //lower motor power by 20%
const uint BUTTON_20UPPER = 3; //raise motor power by 20%
const uint BUTTON_Moff = 4; //motor power set 0%
const uint buttons[] = {BUTTON_5LOWER, BUTTON_5UPPER, BUTTON_20LOWER, BUTTON_20UPPER, BUTTON_Moff};

const int MIN_SPEED = 0; // 0% motor power
const int MAX_SPEED = 80; // max motor power in %

struct udp_pcb* pcb = nullptr;
struct __attribute__((__packed__)) ControllerData { //Object/data container to send
    uint8_t speed;                      
    //tail_pos;
};
ControllerData data = {0}; //create instance of Controllerdata and set values to 0


void init_udp(){
    cyw43_arch_lwip_begin(); 
    pcb = udp_new(); //create new UDP-block
    cyw43_arch_lwip_end();
    
    if(pcb == nullptr){
        printf("Error: Could not create UDP PCB!");
    }
    else{
        printf("UDP sender created.");
    }
}


bool send(){
    if (pcb == nullptr){ //check for pcb
        return false;
    } 
    struct pbuf* p = pbuf_alloc(PBUF_TRANSPORT, sizeof(ControllerData), PBUF_RAM); //allocate RAM for data ip and checksum (PBUF_TRANSPORT: IP und checksum)
    if (p == nullptr){
        printf("NO RAM! CANT SEND!");
        return false;
    }
    pbuf_take(p, &data, sizeof(ControllerData)); //copy data in reserved RAM
    
    ip_addr_t client_IP;
    ip_addr_set_ip4_u32(&client_IP, IPADDR_BROADCAST); //client IP is broadcast IP
    
    cyw43_arch_lwip_begin(); //stop lwip background process
    err_t feedback = udp_sendto(pcb, p,&client_IP ,4210); //Broadcast on Port 4210
    cyw43_arch_lwip_end(); //start lwip background process again
    pbuf_free(p); //clear buffer

    if (feedback != ERR_OK){ //if sending failed return false
        return false;
    }
    return true;    
}


void change_speed(uint8_t& speed, int difference ){
    int new_speed = speed + difference;
    if (new_speed < MIN_SPEED){
        new_speed = MIN_SPEED;
    }
    else if (new_speed > MAX_SPEED){
        new_speed = MAX_SPEED;
    }
    speed = (uint8_t)new_speed;
}



int main()
{
    stdio_init_all(); //debuggin allow printf

    while (!stdio_usb_connected()) {
        sleep_ms(100);
    }
    printf("USB verbunden! Start...\n");

    while (cyw43_arch_init()) { //initialize wlan chip and network stack
        printf("WLAN ERROR! Try again in 1 second.\n");
        sleep_ms(1000);
    }
    cyw43_arch_enable_ap_mode(SSID, PW, CYW43_AUTH_WPA2_AES_PSK); //configure pico as access point
    
    for (uint pin : buttons){
        gpio_init(pin);   // initialize pin for standard I/O use
        gpio_set_dir(pin, GPIO_IN); //set pin as input
        gpio_pull_up(pin); //activate integrated pull up resistor
    }
    
    bool L5_was_pressed = false;
    bool U5_was_pressed = false;
    bool L20_was_pressed = false;
    bool U20_was_pressed = false;
    bool MO_was_pressed = false;
    uint32_t last_send_time = 0;
    
    init_udp();
    watchdog_enable(200, true); //200ms not fed forces reboot (true = pause while debugging at pc)

    while(true){
        bool L5_pressed = !gpio_get(BUTTON_5LOWER);
        bool U5_pressed = !gpio_get(BUTTON_5UPPER);
        bool L20_pressed = !gpio_get(BUTTON_20LOWER);
        bool U20_pressed = !gpio_get(BUTTON_20UPPER);
        bool MO_pressed = !gpio_get(BUTTON_Moff);
        bool change = false;
        bool success = false;
        uint32_t actual_time = to_ms_since_boot(get_absolute_time());

        if(L5_pressed && !L5_was_pressed){ //prevent multiple triggers if button is held
            change_speed(data.speed, -5);
            change = true;
        }
        L5_was_pressed = L5_pressed;
        
        if (U5_pressed && !U5_was_pressed){
            change_speed(data.speed, 5);
            change = true;
        }
        U5_was_pressed = U5_pressed;

        if (L20_pressed && !L20_was_pressed){
            change_speed(data.speed, -20);
            change = true;
        }
        L20_was_pressed = L20_pressed;

        if (U20_pressed && !U20_was_pressed){
            change_speed(data.speed, 20);
            change = true;
        }
        U20_was_pressed = U20_pressed;

        if(MO_pressed && !MO_was_pressed){
            data.speed = MIN_SPEED;
            change = true;
        }
        MO_was_pressed = MO_pressed;
        
        if (change || actual_time - last_send_time >= 50){ //send if new input detected or 50 ms passed
            success = send();
            last_send_time = actual_time;
        }
        else{
            success = true;
        }

        if (success){ //feed the dog if sending was successfull
            watchdog_update();
        }
        printf("sending %d\n", data.speed);
        sleep_ms(10); // protect CPU and debounce

    }

}
