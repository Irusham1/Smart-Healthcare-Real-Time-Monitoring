#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"

MAX30105 particleSensor;

long lastBeat = 0;
float beatsPerMinute;
int beatAvg;

void setup() {
  Serial.begin(115200);
  delay(1000);

  // Initialize sensor
  if (!particleSensor.begin(Wire, I2C_SPEED_STANDARD)) {
    Serial.println("MAX30102 not found. Check wiring.");
    while (1);
  }

  // Sensor configuration
  particleSensor.setup();  // Default = 50Hz, pulse width 69us
  particleSensor.setPulseAmplitudeRed(0x0A); // Low red LED
  particleSensor.setPulseAmplitudeIR(0x0A);  // Low IR LED

  Serial.println("Place your finger on the sensor...");
}

void loop() {
  long irValue = particleSensor.getIR();

  if (checkForBeat(irValue)) {
    long delta = millis() - lastBeat;
    lastBeat = millis();

    beatsPerMinute = 60 / (delta / 1000.0);
    beatAvg = (beatAvg * 3 + beatsPerMinute) / 4;

    Serial.print("💓 BPM: ");
    Serial.print(beatsPerMinute);
    Serial.print("  |  AVG BPM: ");
    Serial.println(beatAvg);
    
  }

  delay(20);
}
