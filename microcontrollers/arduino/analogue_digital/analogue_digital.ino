#define NUM_ANALOGUE_PINS 6
#define NUM_DIGITAL_PINS 4
#define JOYSTICK_Z_PIN 7

// List of Pins
uint8_t analogue_pins[] = {A8, A9, A10, A11, A12, A13};
uint8_t digital_pins[] = {4, 5, 6, 7};

unsigned long data_period = 100;

// Define Array to Store Current Values
int analogue_values[NUM_ANALOGUE_PINS];
byte digital_values[NUM_DIGITAL_PINS];

char paddedString[5];

void setup() {
  // Open Serial Link
  Serial.begin(9600);

  // Set the mode for the digital pins
  for (int i = 0; i < NUM_DIGITAL_PINS; i++) {
    pinMode(digital_pins[i], INPUT_PULLUP);
  }
}

void loop() {
  // Read and Update Values for all Analogue Pins
  for (int i = 0; i < NUM_ANALOGUE_PINS; i++) {
    analogue_values[i] = analogRead(analogue_pins[i]);

    // sprintf(paddedString, "%04d", analogue_values[i]);
    Serial.print(analogue_values[i]);
    
    // Conditionally print the comma to clean up the output
    if (i < NUM_ANALOGUE_PINS - 1) { 
      Serial.print(";");
    }
  }

  Serial.print(";");

  // Read and Update Values for all Digital Pins
  for (int i = 0; i < NUM_DIGITAL_PINS; i++) {
    digital_values[i] = digitalRead(digital_pins[i]);

    if (digital_pins[i] == JOYSTICK_Z_PIN) {
      digital_values[i] = !digital_values[i];
    }

    Serial.print(digital_values[i]);
    
    // Conditionally print the comma to clean up the output
    if (i < NUM_DIGITAL_PINS - 1) { 
      Serial.print(";");
    }
  }

  Serial.println("");

  delay(data_period);
}
