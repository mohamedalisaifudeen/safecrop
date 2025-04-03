#define TINY_GSM_MODEM_SIM800  

#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <TinyGsmClient.h>
#include <SoftwareSerial.h>

// LCD and sensor configurations
LiquidCrystal_I2C lcd(0x27, 16, 2);

SoftwareSerial mySerial(7, 8);  // SIM800L TX to D7, RX to D8

TinyGsm modem(mySerial);

const int trapWirePin = A1;
float voltage = 0.0;
const float voltageThreshold = 2.5;  // Threshold for voltage drop detection
const int vibrationPin = 3;
const int trigPin = 6;
const int echoPin = 7;
const int buzzer = 5;  // Buzzer connected to pin 5

long duration;
int distance;
int vibrationState = 0;
const int distanceThreshold = 200;

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Monitoring...");

  mySerial.begin(9600);  // Start SIM800L communication
  delay(3000);

  pinMode(vibrationPin, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzer, OUTPUT);
}

void loop() {
  vibrationState = digitalRead(vibrationPin);

  // Measure distance using ultrasonic sensor
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;  // Convert to cm

  Serial.print("Vibration: ");
  Serial.print(vibrationState);
  Serial.print(" | Distance: ");
  Serial.print(distance);
  Serial.println(" cm");

  if (vibrationState == HIGH && distance < distanceThreshold) {
    Serial.println("🚨 Elephant Detected!");
  }

  delay(500);

  int analogValue = analogRead(trapWirePin);
  voltage = (analogValue / 1023.0) * 5.0;

  lcd.setCursor(0, 1);
  lcd.print("Voltage:     ");
  lcd.setCursor(9, 1);
  lcd.print(voltage, 2);
  lcd.print(" V ");

  Serial.println(voltage);

  if (voltage < voltageThreshold) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Voltage Drop!");

    // **Activate Buzzer**
    for (int i = 0; i < 4; i++) {  // Buzzer will sound in pulses
      tone(buzzer, 1000);  // Play a 1kHz sound
      delay(300);  // Sound duration
      noTone(buzzer);  // Stop sound
      delay(300);  // Pause
    }

    // **Send SMS while buzzer is active**
    SendMessage();

    delay(2000);
    lcd.clear();
  }
}

// Function to send an SMS alert
void SendMessage() {
  modem.sendSMS("+94742668716", "Elephant entered the paddy field");
  Serial.println("SMS Sent!");
}
