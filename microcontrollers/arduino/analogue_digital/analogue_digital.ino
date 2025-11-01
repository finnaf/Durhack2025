#define NUM_ANALOGUE_PINS 1
#define NUM_DIGITAL_PINS 1

uint8_t analogue_pins[] = {A0, A1, A2, A3, A4};
uint8_t digital_pins[] = {4, 5, 6, 7};

int analogue_values[NUM_ANALOGUE_PINS];
int digital_values[NUM_DIGITAL_PINS];

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  for (int i = 0; i < NUM_DIGITAL_PINS; i++) {
    pinMode(digital_pins[i], INPUT_PULLUP);
  }

  // pinMode(digital_sensor_button_pin, INPUT_PULLUP);
}

void loop() {
  Serial.print("Analogue: {");
  for (int i = 0; i < NUM_ANALOGUE_PINS; i++) {
    analogue_values[i] = analogRead(analogue_pins[i]);
    Serial.print(analogue_values[i]);
    Serial.print(", ");
  }
  Serial.println("}");

  Serial.print("Digital: {");
  for (int i = 0; i < NUM_DIGITAL_PINS; i++) {
    digital_values[i] = digitalRead(digital_pins[i]);
    Serial.print(digital_values[i]);
    Serial.print(", ");
  }
  Serial.println("}");
}
