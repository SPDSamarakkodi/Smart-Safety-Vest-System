#include <TinyGPS++.h>
#include <SoftwareSerial.h>

TinyGPSPlus gps;

SoftwareSerial ss(D6, D5);

void setup() {
  Serial.begin(115200);
  ss.begin(9600);

  Serial.println("GPS TEST");
}

void loop() {

  while (ss.available()) {
    gps.encode(ss.read());

    if (gps.location.isUpdated()) {

      Serial.print("Lat: ");
      Serial.println(gps.location.lat());

      Serial.print("Lng: ");
      Serial.println(gps.location.lng());
    }
  }
}