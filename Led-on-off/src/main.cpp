#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <PubSubClient.h>
#include "wifi_mqtt_connect.h"
#include <ArduinoJson.h>

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
  pinMode(D0, INPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, INPUT);
}

void commands(char *json_in)
{
  JsonDocument doc;
  deserializeJson(doc, json_in);

  if (!strcmp(doc["cmd"], "DW"))
  {
    dw(doc["pin"], doc["value"]);
  }
  else
  {
    client.publish("toNodeRed", "command not found!");
  }
}

void dw(char *pin, byte value)
{
  if (!strcmp(pin, "D1"))
  {
    digitalWrite(D1, value);
    client.publish("toNodeRed", "D1 receved command!");
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

  /*if (!strcmp(msg2, "DRD0"))
  {
    if (digitalRead(D0))
    {
      client.publish("D0State", strcpy(msg2, "[true]"));
    }
    else
    {
      client.publish("D0State", strcpy(msg2, "[false]"));
    }
  }
  else if (!strcmp(msg2, "DWBH"))
  {
    digitalWrite(LED_BUILTIN, HIGH);
    client.publish("toNodeRed", strcpy(msg2, "[Builtin,HIGH]"));
  }
  else if (!strcmp(msg2, "DWD1H"))
  {
    digitalWrite(D1, HIGH);
  }
  else if (!strcmp(msg2, "DWD2H"))
  {
    digitalWrite(D2, HIGH);
  }
  else if (!strcmp(msg2, "DWD3H"))
  {
    digitalWrite(D3, HIGH);
  }
  else if (!strcmp(msg2, "DWD4H"))
  {
    digitalWrite(D4, HIGH);
  }
  else if (!strcmp(msg2, "DWBL"))
  {
    digitalWrite(LED_BUILTIN, LOW);
    client.publish("toNodeRed", strcpy(msg2, "[Buitin,LOW]"));
  }
  else if (!strcmp(msg2, "DWD1L"))
  {
    digitalWrite(D1, LOW);
  }
  else if (!strcmp(msg2, "DWD2L"))
  {
    digitalWrite(D4, LOW);
  }
  else if (!strcmp(msg2, "DWD4L"))
  {
    digitalWrite(D2, LOW);
  }
  else if (!strcmp(msg2, "DWD3L"))
  {
    digitalWrite(D3, LOW);
  }
  else if (!strcmp(msg2, "DWD4L"))
  {
    digitalWrite(D4, LOW);
  }
  else if (!strcmp(msg2, "DRD2"))
  {
    if (digitalRead(D2))
    {
      client.publish("D2State", strcpy(msg2, "[true]"));
    }
    else
    {
      client.publish("D2State", strcpy(msg2, "[false]"));
    }
  }
  else
  {
    client.publish("toNodeRed", "command not found!");
  }*/
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
      client.subscribe("fromNodeRed");
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