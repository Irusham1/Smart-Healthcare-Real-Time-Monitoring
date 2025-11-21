#include <WiFi.h>
#include <HTTPClient.h>

// Your Wi-Fi credentials
#define WIFI_SSID "Galaxy A10sdec0"
#define WIFI_PASSWORD "11111112"

// Firebase project credentials
#define DATABASE_URL "https://iot-health-monitoring-sy-b19b8-default-rtdb.firebaseio.com"

void setup() {
  Serial.begin(115200);
  delay(1000);
  
  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  
  // Test send temperature data
  float temperature = 36.8;
  sendToFirebase(temperature);
}

void loop() {
  // Send temperature data every 10 seconds
  float temperature = 36.8 + (random(-20, 20) / 10.0); // Simulate temperature readings
  sendToFirebase(temperature);
  
  delay(10000);
}

void sendToFirebase(float temperature) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    
    // Firebase REST API URL (without API key for public database)
    String url = String(DATABASE_URL) + "/patient1/temperature.json";
    
    Serial.println("Sending to: " + url);
    
    http.begin(url);
    http.addHeader("Content-Type", "application/json");
    
    // Simple JSON string
    String jsonData = String(temperature);
    
    Serial.println("Sending data: " + jsonData);
    
    // Send PUT request
    int httpResponseCode = http.PUT(jsonData);
    
    Serial.print("HTTP Response Code: ");
    Serial.println(httpResponseCode);
    
    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println("✅ Success! Response: " + response);
      Serial.println("Temperature sent: " + String(temperature) + "°C");
    } else {
      Serial.println("❌ Failed to send data");
    }
    
    http.end();
  } else {
    Serial.println("❌ WiFi not connected");
  }
}

// Alternative function using WiFiClient (if HTTPClient doesn't work)
void sendToFirebaseAlternative(float temperature) {
  WiFiClient client;
  
  if (client.connect("iot-health-monitoring-sy-b19b8-default-rtdb.firebaseio.com", 443)) {
    Serial.println("Connected to Firebase");
    
    String postData = String(temperature);
    String request = "PUT /patient1/temperature.json HTTP/1.1\r\n";
    request += "Host: iot-health-monitoring-sy-b19b8-default-rtdb.firebaseio.com\r\n";
    request += "Content-Type: application/json\r\n";
    request += "Content-Length: " + String(postData.length()) + "\r\n";
    request += "Connection: close\r\n\r\n";
    request += postData;
    
    client.print(request);
    
    while (client.connected()) {
      if (client.available()) {
        String response = client.readString();
        Serial.println("Response: " + response);
        break;
      }
    }
    client.stop();
  } else {
    Serial.println("❌ Connection to Firebase failed");
  }
}