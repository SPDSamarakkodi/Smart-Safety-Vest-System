#include <DHT.h>

#define DHTPIN D4
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);

void setup() {

  Serial.begin(115200);

  dht.begin();

  Serial.println("DHT11 Testing...");
}

void loop() {

  float temp = dht.readTemperature();
  float hum = dht.readHumidity();

  Serial.print("Temperature : ");
  Serial.print(temp);
  Serial.println(" °C");

  Serial.print("Humidity : ");
  Serial.print(hum);
  Serial.println(" %");

  Serial.println("----------------");

  delay(2000);

}