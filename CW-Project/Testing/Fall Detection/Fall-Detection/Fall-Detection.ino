#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

void setup() {
  Serial.begin(115200);

  Wire.begin(D2, D1);

  mpu.initialize();

  if(mpu.testConnection()){
    Serial.println("MPU6050 Connected!");
  } else {
    Serial.println("MPU6050 Failed!");
  }
}

void loop() {
}