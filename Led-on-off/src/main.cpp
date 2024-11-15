#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <PubSubClient.h>
#include "wifi_mqtt_connect.h"
#include <ArduinoJson.h>

void callback(char *topic, byte *payload, unsigned int length);
void commands(char *json_in);
void setup_wifi();

WiFiClient espClient;
PubSubClient client(espClient);
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE (50)
char msg[MSG_BUFFER_SIZE];

int value = 0;

void setup()
{
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
  pinMode(D0, OUTPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
}

void commands(char *json_in)
{
  JsonDocument doc;
  deserializeJson(doc, json_in);

  byte line = doc["gpio"];
  byte value = doc["value"];

  if (!strcmp(doc["cmd"], "DW"))
  {
    digitalWrite(line, value);
  }else if(doc["cmd"], "AW"){
    analogWrite(line, value);
  }
  else
  {
    client.publish("toNodeRed", "command not found!");
  }
}


void setup_wifi()
{

  Serial.begin(9600);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char *topic, byte *payload, unsigned int length)
{
  char msg2[MSG_BUFFER_SIZE] = "";
  byte i = 0;

  for (i = 0; i < length; i++)
  {
    msg2[i] = (char)payload[i];
  }
  msg2[i] = '\0';

  client.publish("toNodeRed", msg2);

  commands(msg2);

}

void reconnect()
{
  // Loop until we're reconnected
  while (!client.connected())
  {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (client.connect(clientId.c_str(), mqtt_user, mqtt_password))
    {
      Serial.println("connected");
      // ... and resubscribe
      client.subscribe("toDevice_0");
    }
    else
    {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void loop()
{

  if (!client.connected())
  {
    reconnect();
  }
  client.loop();
}