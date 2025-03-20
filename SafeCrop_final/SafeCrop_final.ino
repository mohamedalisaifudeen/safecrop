#define TINY_GSM_MODEM_SIM800  

#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <TinyGsmClient.h>
#include <ArduinoHttpClient.h>

// LCD and sensor configurations
LiquidCrystal_I2C lcd(0x27, 16, 2);

#define TINY_GSM_MODEM_SIM800  // Define GSM module
#include <SoftwareSerial.h>
SoftwareSerial mySerial(7, 8);  // SIM800L TX to D7, RX to D8

TinyGsm modem(mySerial);
TinyGsmClient client(modem);
const char server[] = "16.171.55.209";  // Change this to your backend IP
const int port = 5000;
HttpClient http(client, server, port);

const int trapWirePin = A1;
float voltage = 0.0;
const float voltageThreshold = 2.5;  // Threshold for voltage drop detection
const int vibrationPin = 3;
const int trigPin = 6;
const int echoPin = 7;

long duration;
int distance;
int vibrationState = 0;
const int distanceThreshold = 200;
const String docid = "3VmaoJABUAYTCSzPBXSE";  // Replace with actual docid

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Monitoring...");

  mySerial.begin(9600);  // Start SIM800L communication
  delay(3000);

  Serial.println("Initializing modem...");
  if (!modem.restart()) {
    Serial.println("Modem failed to restart");
  }

  Serial.println("Connecting to GPRS...");
  if (!modem.gprsConnect("dialogbb", "", "")) {  // Change APN if needed
    Serial.println("GPRS connection failed!");
  } else {
    Serial.println("GPRS connected.");
  }

  pinMode(vibrationPin, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

// Function to send system status to backend
void sendStatusToServer(int status) {
  Serial.println("Sending system status to server...");

  String jsonData = "{\"docid\":\"" + docid + "\",\"status\": " + String(status) + "}";
  Serial.println("JSON Data: " + jsonData);

  http.beginRequest();
  http.post("/update_status");
  http.sendHeader("Content-Type", "application/json");
  http.sendHeader("Content-Length", jsonData.length());
  http.beginBody();
  http.print(jsonData);
  http.endRequest();

  int statusCode = http.responseStatusCode();
  String response = http.responseBody();

  Serial.print("Response Code: ");
  Serial.println(statusCode);
  Serial.print("Response: ");
  Serial.println(response);

  if (statusCode != 200) {
    Serial.println("Error sending data!");
  } else {
    Serial.println("Status updated successfully.");
  }
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
    SendMessage();

    // Send system status to backend as "inactive"
    sendStatusToServer(0);

    delay(2000);
    lcd.clear();
  } else {
    // Send system status to backend as "active"
    sendStatusToServer(1);
  }
}

// Function to send an SMS alert
void SendMessage() {
  modem.sendSMS("+94754531281", "Elephant entered the paddy field");
  Serial.println("SMS Sent!");
}
