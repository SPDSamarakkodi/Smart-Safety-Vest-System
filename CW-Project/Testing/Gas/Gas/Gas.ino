#define MQ7 A0

void setup() {

  Serial.begin(115200);

}

void loop() {

  int gas = analogRead(MQ7);

  Serial.print("Gas Value : ");

  Serial.println(gas);

  delay(1000);

}