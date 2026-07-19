#include <Wire.h>
#include "MAX30105.h"

MAX30105 sensor;

void setup() {
  Serial.begin(115200);

  Wire.begin(D2, D1);

  if (!sensor.begin()) {
    Serial.println("MAX30102 NOT FOUND");
    while (1);
  }

  Serial.println("MAX30102 Connected");
}

void loop() {
}