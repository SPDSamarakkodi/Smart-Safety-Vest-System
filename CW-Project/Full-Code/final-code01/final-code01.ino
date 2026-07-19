#include <ESP8266WiFi.h>
#include <Firebase.h>
#include "secrets.h"

#include <Wire.h>
#include <DHT.h>
#include <MPU6050.h>

#include "MAX30105.h"
#include "heartRate.h"

#include <SoftwareSerial.h>
#include <TinyGPS++.h>
#include <math.h>

//=================================================
// PIN DEFINITIONS
//=================================================

#define DHTPIN D4
#define DHTTYPE DHT11

#define MQ7_PIN A0

#define BUZZER D7
#define LED D0

#define GPS_RX D6
#define GPS_TX D5

//=================================================
// OBJECTS
//=================================================

DHT dht(DHTPIN, DHTTYPE);
MPU6050 mpu;
MAX30105 particleSensor;
SoftwareSerial gpsSerial(GPS_RX, GPS_TX);
TinyGPSPlus gps;
Firebase fb(REFERENCE_URL);

//=================================================
// VARIABLES
//=================================================

float temperature = 0;
float humidity = 0;

int gasValue = 0;

float BPM = 0;
int heartRate = 0;
int AvgBPM = 0;

bool fallDetected = false;

double latitude = 0;
double longitude = 0;

int16_t ax, ay, az;

long lastBeat = 0;

const byte RATE_SIZE = 10;
byte rates[RATE_SIZE];
byte rateSpot = 0;
byte validReadings = 0;

long irValue = 0;

unsigned long lastFirebase = 0;
unsigned long lastPrint = 0;

//=================================================
// HEART CALLBACK
//=================================================

void onBeatDetected()
{
    Serial.println("*** BEAT DETECTED ***");
}

//=================================================
// SETUP
//=================================================

void setup()
{
    Serial.begin(115200);

    pinMode(BUZZER, OUTPUT);
    pinMode(LED, OUTPUT);

    digitalWrite(BUZZER, LOW);
    digitalWrite(LED, LOW);

    Wire.begin(D2, D1);

    // DHT
    dht.begin();

    // MPU6050
    Serial.println("Initializing MPU6050...");

    mpu.initialize();

    if (mpu.testConnection())
        Serial.println("MPU6050 Connected");
    else
        Serial.println("MPU6050 FAILED");

    //=================================================
    // MAX30102
    //=================================================

    Serial.println("Initializing MAX30102...");

    if (!particleSensor.begin(Wire, I2C_SPEED_STANDARD))
    {
        Serial.println("MAX30102 FAILED");
        while (1);
    }

    particleSensor.setup(
        20,     // LED brightness
        4,      // sample average
        2,      // RED + IR
        400,    // sample rate
        411,    // pulse width
        4096    // ADC range
    );

    particleSensor.setPulseAmplitudeRed(0x0A);
    particleSensor.setPulseAmplitudeGreen(0);

    Serial.println("MAX30102 Connected");
    Serial.println("Place finger on sensor");

    // GPS
    gpsSerial.begin(9600);
    Serial.println();
    Serial.println("======================");
    Serial.println("ESP8266 GPS TEST");
    Serial.println("======================");

    Serial.println("Waiting for GPS signal...");

    // WiFi
    Serial.print("Connecting WiFi");

    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }

    Serial.println();
    Serial.println("WiFi Connected");
}

//=================================================
// LOOP
//=================================================

void loop()
{
    //=================================================
    // HEART SENSOR FIRST
    //=================================================

    irValue = particleSensor.getIR();

    if (irValue < 50000)
    {
        BPM = 0;
        heartRate = 0;
    }
    else if (irValue >= 260000)
    {
        Serial.println("Signal too strong");
    }
    else
    {
        if (checkForBeat(irValue))
        {
            onBeatDetected();

            long delta = millis() - lastBeat;
            lastBeat = millis();

            BPM = 60.0 / (delta / 1000.0);

            if (BPM > 40 && BPM < 180)
            {
                rates[rateSpot++] = (byte)BPM;
                rateSpot %= RATE_SIZE;

                if (validReadings < RATE_SIZE)
                    validReadings++;

                AvgBPM = 0;

                for (byte i = 0; i < validReadings; i++)
                {
                    AvgBPM += rates[i];
                }

                AvgBPM /= validReadings;

                heartRate = AvgBPM;
            }
        }
    }

    //=================================================
    // DHT11
    //=================================================

    temperature = dht.readTemperature();
    humidity = dht.readHumidity();

    //=================================================
    // MQ7
    //=================================================

    gasValue = analogRead(MQ7_PIN);

    //=================================================
    // MPU6050
    //=================================================

    mpu.getAcceleration(&ax, &ay, &az);

    float x = ax / 16384.0;
    float y = ay / 16384.0;
    float z = az / 16384.0;

    float totalAccel =
        sqrt(x*x + y*y + z*z);

    fallDetected = (totalAccel > 2.5);

    //=================================================
    // GPS
    //=================================================

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
  }

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



  // If GPS is not connected or no data
  if (millis() > 5000 && gps.charsProcessed() < 10) {

    Serial.println("ERROR: No GPS data received");
    Serial.println("Check wiring and baud rate");

    delay(2000);
  }















    if (gps.location.isValid())
{
    latitude = gps.location.lat();
    longitude = gps.location.lng();

    Serial.print("Latitude : ");
    Serial.println(latitude, 6);

    Serial.print("Longitude : ");
    Serial.println(longitude, 6);
}

    //=================================================
    // ALERT
    //=================================================

    if(gasValue > 300 ||
       fallDetected ||
       heartRate > 110)
    {
        digitalWrite(BUZZER, HIGH);
        digitalWrite(LED, HIGH);
    }
    else
    {
        digitalWrite(BUZZER, LOW);
        digitalWrite(LED, LOW);
    }

    //=================================================
    // FIREBASE
    //=================================================

    if (millis() - lastFirebase > 10000)
    {
        lastFirebase = millis();

        fb.setFloat("sensor/temperature", temperature);
        fb.setFloat("sensor/humidity", humidity);
        fb.setInt("sensor/gas", gasValue);
        fb.setInt("sensor/heartRate", heartRate);
        fb.setBool("sensor/fall", fallDetected);

        fb.setString("gps/latitude", String(latitude, 6));
        fb.setString("gps/longitude", String(longitude, 6));
    }

    //=================================================
    // SERIAL MONITOR
    //=================================================

    if (millis() - lastPrint > 1000)
    {
        lastPrint = millis();

        Serial.println();
        Serial.println("========== SENSOR DATA ==========");

        Serial.print("Temperature: ");
        Serial.print(temperature);
        Serial.println(" C");

        Serial.print("Humidity: ");
        Serial.print(humidity);
        Serial.println(" %");

        Serial.print("MQ7: ");
        Serial.println(gasValue);

        Serial.print("IR Value: ");
        Serial.println(irValue);

        Serial.print("Heart Rate: ");
        Serial.print(BPM);
        Serial.println(" BPM");

        Serial.print("Average BPM: ");
        Serial.println(heartRate);

        Serial.print("AX:");
        Serial.print(ax);

        Serial.print(" AY:");
        Serial.print(ay);

        Serial.print(" AZ:");
        Serial.println(az);

        Serial.print("Fall Detected: ");
        Serial.println(fallDetected);

        Serial.print("Latitude: ");
        Serial.println(latitude, 6);

        Serial.print("Longitude: ");
        Serial.println(longitude, 6);

        Serial.println("=================================");
    }

    // important for ESP8266 WiFi tasks
    yield();
}