int analogue_sensor_pentiometer = A0;
int analogue_pentiometer_sensor_value = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  analogue_pentiometer_sensor_value = analogRead(analogue_sensor_pentiometer);
  Serial.print("Joycon: ");
  Serial.println(analogue_pentiometer_sensor_value);

}
