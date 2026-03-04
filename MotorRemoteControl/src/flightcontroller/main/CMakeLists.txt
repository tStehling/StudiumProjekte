idf_component_register(SRCS "flightcontroller.cpp"
                    INCLUDE_DIRS "."
                    REQUIRES nvs_flash esp_wifi esp_event driver esp_timer lwip)
