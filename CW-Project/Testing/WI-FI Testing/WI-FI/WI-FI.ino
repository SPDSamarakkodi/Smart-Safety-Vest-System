#include <ESP8266WiFi.h>
#define SSID "SAMSUNG GALAXY A9(2018)"
#define Password "123456788"
void setup() {
    Serial.begin(115200);
      Serial.print("Connecting to ");
  // put your setup code here, to run once:
     WiFi.begin(SSID,Password);
       while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  // put your main code here, to run repeatedly:
     
}