int analogue_sensor_pentiometer_pin = A0;
int analogue_sensor_pentiometer_value = 0;
int digital_sensor_button_pin = 4;
int digital_sensor_button_value = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  pinMode(digital_sensor_button_pin, INPUT_PULLUP);
}

void loop() {
  // put your main code here, to run repeatedly:
  analogue_sensor_pentiometer_value = analogRead(analogue_sensor_pentiometer_pin);
  Serial.print("Joycon: ");
  Serial.println(analogue_sensor_pentiometer_value);

  digital_sensor_button_value = digitalRead(digital_sensor_button_pin);
  Serial.print("Button: ");
  Serial.println(digital_sensor_button_value);
}
