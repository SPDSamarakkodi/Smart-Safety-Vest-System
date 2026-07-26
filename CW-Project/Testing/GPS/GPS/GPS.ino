#include <TinyGPS++.h>
#include <SoftwareSerial.h>

// ESP8266 GPS Pins
#define GPS_RX D6   // ESP RX  <- GPS TX
#define GPS_TX D5   // ESP TX  -> GPS RX

TinyGPSPlus gps;

SoftwareSerial gpsSerial(GPS_RX, GPS_TX);


void setup() {

  Serial.begin(115200);

  gpsSerial.begin(9600);

  Serial.println();
  Serial.println("======================");
  Serial.println("ESP8266 GPS TEST");
  Serial.println("======================");

  Serial.println("Waiting for GPS signal...");
}


void loop() {

  // Read GPS data
  while (gpsSerial.available()) {

    gps.encode(gpsSerial.read());

  }


  // Display GPS information
  if (gps.location.isUpdated()) {

    Serial.println("----------------------");

    Serial.print("Latitude : ");
    Serial.println(gps.location.lat(), 6);


    Serial.print("Longitude: ");
    Serial.println(gps.location.lng(), 6);


    Serial.print("Altitude : ");
    Serial.print(gps.altitude.meters());
    Serial.println(" m");


    Serial.print("Satellites: ");
    Serial.println(gps.satellites.value());


    Serial.print("HDOP: ");
    Serial.println(gps.hdop.value());


    if (gps.date.isValid()) {

      Serial.print("Date: ");

      Serial.print(gps.date.day());
      Serial.print("/");

      Serial.print(gps.date.month());
      Serial.print("/");

      Serial.println(gps.date.year());

    }


    if (gps.time.isValid()) {

      Serial.print("Time: ");

      if (gps.time.hour() < 10)
        Serial.print("0");

      Serial.print(gps.time.hour());
      Serial.print(":");


      if (gps.time.minute() < 10)
        Serial.print("0");

      Serial.print(gps.time.minute());
      Serial.print(":");


      if (gps.time.second() < 10)
        Serial.print("0");

      Serial.println(gps.time.second());

    }


    Serial.println("----------------------");
  }



  // If GPS is not connected or no data
  if (millis() > 5000 && gps.charsProcessed() < 10) {

    Serial.println("ERROR: No GPS data received");
    Serial.println("Check wiring and baud rate");

    delay(2000);
  }


}