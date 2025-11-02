#define NUM_ANALOGUE_PINS 1
#define NUM_DIGITAL_PINS 3

// List of Pins
uint8_t analogue_pins[] = {A11, A12, A13, A14, A15};
uint8_t digital_pins[] = {4, 5, 6, 7};

// Define Array to Store Current Values
int analogue_values[NUM_ANALOGUE_PINS];
int digital_values[NUM_DIGITAL_PINS];

void setup() {
  // Open Serial Link
  Serial.begin(9600);

  // Set the mode for the digital pins
  for (int i = 0; i < NUM_DIGITAL_PINS; i++) {
    pinMode(digital_pins[i], INPUT_PULLUP);
  }
}

void loop() {
  Serial.print("Analogue: {");
  // Read and Update Values for all Analogue Pins
  for (int i = 0; i < NUM_ANALOGUE_PINS; i++) {
    analogue_values[i] = analogRead(analogue_pins[i]);
    Serial.print(analogue_values[i]);
    Serial.print(", ");
  }
  Serial.println("}");

  Serial.print("Digital: {");
  // Read and Update Values for all Digital Pins
  for (int i = 0; i < NUM_DIGITAL_PINS; i++) {
    digital_values[i] = digitalRead(digital_pins[i]);
    Serial.print(digital_values[i]);
    Serial.print(", ");
  }
  Serial.println("}");
}
