
#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <PubSubClient.h>
#include "wifi_mqtt_connect.h"


WiFiClient espClient;
PubSubClient client(espClient);
SoftwareSerial mySerial = SoftwareSerial(D3, D4);  //GPIO0, GPIO2
unsigned long lastMsg = 0;
#define MSG_BUFFER_SIZE (50)
char msg[MSG_BUFFER_SIZE];
int value = 0;

void setup_serial_ports() {
  pinMode(D3, INPUT);
  pinMode(D4, OUTPUT);
  mySerial.begin(9600);
  Serial.begin(115200);
}

void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

/*
void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();
}
*/

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  String hexconv = "0123456789ABCDEF";
  byte data, temp;

  for (byte i = 0; i < length - 1; i = i + 3) {
    mySerial.print(hexconv.indexOf((char)payload[i]), 16);
    mySerial.print(hexconv.indexOf((char)payload[i + 1]), 16);
  }
  mySerial.println();
  
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (client.connect(clientId.c_str(), mqtt_user, mqtt_password)) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish("toNodeRed", "connected!");
      // ... and resubscribe
      client.subscribe("fromNodeRed");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);  // Initialize the BUILTIN_LED pin as an output
  setup_serial_ports();
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  boolean receved_msg = false;
  char buffer[20];
  byte i = 0;
  byte test = 0;

  while (Serial.available() > 0) {
    test++;
    receved_msg = true;
    // read the incoming byte:
    buffer[i++] = Serial.read();
  }
  buffer[i] = '\0';
  if (receved_msg) {
    receved_msg = false;
    Serial.print("Publish message: ");
    Serial.println(buffer);
    Serial.println(test);
    client.publish("toNodeRed", buffer);
  }
}

/**
void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  unsigned long now = millis();
  if (now - lastMsg > 2000) {
    lastMsg = now;
    ++value;
    snprintf (msg, MSG_BUFFER_SIZE, "hello world #%ld", value);
    Serial.print("Publish message: ");
    Serial.println(msg);
    client.publish("toNodeRed", msg);
  }
}
**/
