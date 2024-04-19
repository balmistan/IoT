#ifndef MQTT_CONNECT_H
#define MQTT_CONNECT_H

#include <PubSubClient.h>

WiFiClient espClient;
PubSubClient client(espClient);

// Replace these with your MQTT settings

const char mqtt_server[]  = "192.168.0.22";
const char mqtt_user[]  = "admin";
const char mqtt_password[] = "dalisan19780";
#endif
