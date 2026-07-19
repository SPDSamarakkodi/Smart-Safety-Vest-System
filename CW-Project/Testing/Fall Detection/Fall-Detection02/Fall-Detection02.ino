#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

int16_t ax,ay,az;

void setup()
{
 Serial.begin(115200);

 Wire.begin(D2,D1);

 mpu.initialize();

 Serial.println("Fall Sensor Test");
}


void loop()
{
 mpu.getAcceleration(&ax,&ay,&az);


 float x=ax/16384.0;
 float y=ay/16384.0;
 float z=az/16384.0;


 float total=sqrt(x*x+y*y+z*z);


 Serial.print("Acceleration: ");
 Serial.println(total);


 if(total > 2.5)
 {
   Serial.println("!!! FALL DETECTED !!!");
 }


 delay(500);
}