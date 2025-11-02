#define NUM_ANALOGUE_PINS 6
#define NUM_DIGITAL_PINS 4
#define JOYSTICK_Z_PIN 7

// #define VERBOSE

// List of Pins
uint8_t analogue_pins[] = {A8, A9, A10, A11, A12, A13};
uint8_t digital_pins[] = {4, 5, 6, 7};

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
#ifdef VERBOSE
  Serial.print("Analogue: {");
#endif

  // Read and Update Values for all Analogue Pins
  for (int i = 0; i < NUM_ANALOGUE_PINS; i++) {
    analogue_values[i] = analogRead(analogue_pins[i]);

#ifdef VERBOSE
    sprintf(paddedString, "%04d", analogue_values[i]);
    Serial.print(paddedString);
    
    // Conditionally print the comma to clean up the output
    if (i < NUM_ANALOGUE_PINS - 1) { 
      Serial.print(", ");
    }
#endif
  }

#ifdef VERBOSE
  Serial.print("}");

  Serial.print("    Digital: {");
#else
  Serial.write((byte*)analogue_values, sizeof(analogue_values));
#endif

  // Read and Update Values for all Digital Pins
  for (int i = 0; i < NUM_DIGITAL_PINS; i++) {
    digital_values[i] = digitalRead(digital_pins[i]);

    if (digital_pins[i] == JOYSTICK_Z_PIN) {
      digital_values[i] = !digital_values[i];
    }

#ifdef VERBOSE
    Serial.print(digital_values[i]);
    
    // Conditionally print the comma to clean up the output
    if (i < NUM_DIGITAL_PINS - 1) { 
      Serial.print(", ");
    }
#endif
  }

#ifdef VERBOSE
  Serial.println("}");
#else
  Serial.write((byte*)digital_values, sizeof(digital_values));
  Serial.println("");
#endif
}
