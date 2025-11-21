# 🏥 IoT Health Monitoring System

This project proposes an IoT-powered system that monitors patients’ vital signs in real time using wearable sensors and cloud technologies. It is designed to help hospitals in Sri Lanka improve patient safety, especially during nighttime when nurses may not always be alert.  The system continuously tracks critical health parameters and sends instant alerts during emergencies.

---

## 📌 Features

- 📡 Real-time sensor data monitoring  
- 💓 Heart Rate, Temperature, SpO2, BPM tracking  
- 📲 Flutter Mobile Application  
- 🔗 Firebase/Thingspeak/MQTT Integration  
- 🚨 Emergency Alert System  
- 📊 Live graphical visualization  
- 🛏 Hospital bed availability / patient management (optional)

---

## 🧰 Tech Stack

### **Hardware**
- ESP32
- Temperature Sensor (DS18B20)
- AD8232 – ECG sensor
- MAX30102 (Heart Rate & SpO₂)
- Jumper Wires  
- Breadboard  
- WiFi connection

![WhatsApp Image 2025-10-27 at 22 39 47_4469e432](https://github.com/user-attachments/assets/5f4b9d05-779d-45d9-b224-c84daa024573)

![WhatsApp Image 2025-10-27 at 22 39 47_c5e7f534](https://github.com/user-attachments/assets/aab38bf7-2705-4814-bcc0-7d2376932435)

### **Software**
- Flutter
- Firebase 
- Arduino IDE (Microcontroller code)

---

## 📱 Flutter App Pages

- 🔐 **Login Page**
- 🏠 **Main Dashboard**
- 🛏 **Beds Availability Page**
- 🚨 **Emergency Alert Page**
- 📊 Live Vitals Monitoring Page

---
## 📷 Screenshots
<img width="537" height="751" alt="Screenshot 2025-10-27 230550" src="https://github.com/user-attachments/assets/aa017b50-f2dc-478b-8494-2458d123053a" />


## ⚙️ Installation & Setup

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/your-username/iot-health-monitoring-system.git
cd iot-health-monitoring-system

2️⃣ Install Flutter Dependencies

flutter pub get

3️⃣ Connect ESP32 / Sensors

Upload the Arduino code from the /hardware folder:

Arduino IDE -> Select board -> Upload

4️⃣ Run the App

flutter run

🖼 System Architecture

ESP32 Sensors → Firebase/MQTT → Flutter App → User

🚨 Emergency Alert System

The system will trigger alerts when:

    Heart rate is abnormal

    Temperature exceeds threshold

    Sensor data is missing

    Manually triggered by user

    Emergency button pressed on dashboard

Alerts can be sent to:

    SMS

    Email

    In-app notification

🛠 How It Works

    Sensors read patient vitals

    ESP32 sends data via WiFi

    Backend stores live data

    Flutter app displays updated vitals

    Alerts triggered if risk detected

Add them like:

![Dashboard](screenshots/dashboard.png)

🚀 Future Improvements

    AI-based health prediction

    Cloud graph analytics

    Wearable device integration

    Offline mode

    Admin dashboard web app

🤝 Contributing

Contributions are welcome!
Feel free to submit issues or pull requests.
