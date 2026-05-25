# Smart Parking — companion app

Flutter app for the ESP8266 [Smart Parking firmware](https://github.com/mazen-salah/smart-parking-webserver). Connects over WebSocket, monitors four parking bays in real time, and controls the entry/exit gates.

## Features

- Real-time bay occupancy with live `H:MM:SS` duration counter
- Entry / exit gate control via Material switches
- Connection status indicator with automatic reconnect
- Pull-to-refresh and explicit snapshot request
- Responsive layout (2 columns on phones, 4 on tablets)
- Dark Material 3 theme

## Architecture

The app follows clean architecture, split into three layers under `lib/`:

```
lib/
├── main.dart
├── app/
│   ├── app.dart                          # MaterialApp + DI wiring
│   └── theme/app_theme.dart
├── core/
│   ├── constants/app_constants.dart
│   └── utils/duration_formatter.dart
└── features/parking/
    ├── data/
    │   ├── datasources/
    │   │   └── parking_websocket_datasource.dart   # raw JSON WS transport
    │   ├── models/
    │   │   └── parking_update_mapper.dart          # JSON → domain types
    │   └── repositories/
    │       └── parking_repository_impl.dart
    ├── domain/
    │   ├── entities/                               # ParkingSpace, Gate, ParkingUpdate (sealed)
    │   └── repositories/parking_repository.dart    # abstract contract
    └── presentation/
        ├── bloc/                                   # ParkingBloc + events + state
        ├── pages/parking_home_page.dart
        └── widgets/                                # ConnectionStatusCard, ParkingGrid, ...
```

- **Domain** has no Flutter or transport dependencies — only Dart + Equatable.
- **Data** implements the domain `ParkingRepository` using a thin WebSocket data source and a mapper that decodes the firmware's [JSON protocol](https://github.com/mazen-salah/smart-parking-webserver/blob/main/docs/PROTOCOL.md).
- **Presentation** uses [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) to expose `ParkingBlocState` to widgets. The page owns a 1 Hz `Timer` solely for repainting the occupancy duration; the bloc handles reconnects.

## Getting started

```bash
flutter pub get
flutter run            # connects to ws://192.168.0.1:81 by default
flutter test
flutter analyze
```

To target a different device, change `AppConstants.websocketUrl` in `lib/core/constants/app_constants.dart`.

## Compatibility

| Tool       | Version           |
|------------|-------------------|
| Flutter SDK | ≥ 3.19           |
| Dart SDK    | ≥ 3.3            |

## Companion firmware

The ESP8266 firmware lives at [mazen-salah/smart-parking-webserver](https://github.com/mazen-salah/smart-parking-webserver). The JSON wire protocol is documented [here](https://github.com/mazen-salah/smart-parking-webserver/blob/main/docs/PROTOCOL.md).

## Demo

[![Demo Video](https://img.youtube.com/vi/odxMqw8v5l0/0.jpg)](https://www.youtube.com/watch?v=odxMqw8v5l0)

## License

MIT — see [LICENSE](LICENSE).
