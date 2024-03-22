# ESP8266 Smart Parking App

This Flutter application serves as a smart parking system interface, allowing users to monitor parking space occupancy and control entry/exit gates using an ESP8266 microcontroller connected via WebSocket.

## Overview

The ESP8266 Smart Parking App provides real-time updates on parking space availability and gate statuses. It communicates with an ESP8266 microcontroller over WebSocket to receive data and send commands for controlling gates. The app interface is designed with simplicity and functionality in mind, offering an intuitive user experience.

## Features

- **Real-time Monitoring**: View the status of parking spaces and gates in real-time.
- **Parking Space Status**: Each parking space is represented visually, showing whether it is occupied or vacant.
- **Occupancy Timer**: Track the duration of parking space occupancy.
- **Gate Control**: Control entry and exit gates with the tap of a button.
- **Connection Status**: Instantly know whether the app is connected to the ESP8266 device.

## Usage

1. **Install Dependencies**: Ensure you have the necessary dependencies installed to run Flutter applications.
2. **Connect to ESP8266**: Make sure your device is connected to the same network as the ESP8266 microcontroller.
3. **Run the App**: Launch the app on your device.
4. **Monitor Parking Spaces**: View the status of parking spaces and gates on the main screen.
5. **Control Gates**: Toggle the switches to open or close entry and exit gates.
6. **Refresh Data**: Tap the refresh icon to update the parking status and gate information.

## Demo Video

[![Demo Video](https://img.youtube.com/vi/odxMqw8v5l0/0.jpg)](https://www.youtube.com/watch?v=odxMqw8v5l0)


Click on the image above to watch the demo video.

## Requirements

- Flutter SDK
- Dart
- ESP8266 microcontroller
- WebSocket server running on the ESP8266 (ws://192.168.0.1:81)

## Getting Started

To get started with this project:

1. Clone the repository.
2. Connect your ESP8266 microcontroller and ensure it's running the WebSocket server.
3. Update the WebSocket server address in the code if necessary.
4. Run the Flutter application on your preferred device.

### Websocket Server
- An Esp8266 Websocket Server is available for controlling the Smart Parking System.
- Repository link: [Smart Parking Server](https://github.com/mazen-salah/smart-parking-webserver)

## Contributing

Contributions are welcome! If you have any suggestions, improvements, or bug fixes, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
