# IoT Helmet Control App

This project demonstrates an **IoT Helmet Control System** with three parts working together:

* **Client (Flutter app)** – UI for connecting and controlling the helmet
* **Server (Node.js)** – backend API and WebSocket handling
* **Simulator (Python)** – device simulator to mimic helmet behavior

## Project Structure

```
IOT-helmet-app/
├── client/       # Flutter frontend
├── server/       # Node.js backend
├── simulator/    # Python helmet simulator
```

## 🚀 Setup & Run

### 1. Clone repository

```bash
git clone https://github.com/your-username/IOT-helmet-app.git
cd IOT-helmet-app
```

### 2. Start Simulator

```bash
cd simulator
pip install -r requirements.txt
python3 simulator.py
```
Simulator running on `ws://localhost:8000`

### 3. Start Server

```bash
cd server
npm install
npm run start
```

Default: **[http://localhost:3000](http://localhost:3000)**

### 4. Run Client

```bash
cd client
flutter pub get
flutter run -d chrome
```

## Features

* **Pair & Connect** with the helmet
* Show real-time **Connection**, **Program State**, and **Last Command**
* Send control commands: **Start**, **Pause**, **Continue**, **Stop**
* Responsive and modular UI (status cards + command buttons)

## 🛠️ Tech Stack

* **Flutter (Dart, Provider)** – frontend
* **Node.js (Express, WebSocket)** – backend
* **Python (asyncio)** – simulator

## ✅ Notes

* Run **all 3 components** for end-to-end functionality.
* Tested locally with Node server bridging client ↔ simulator.
