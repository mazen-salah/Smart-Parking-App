class AppConstants {
  const AppConstants._();

  static const String appName = 'Smart Parking';
  static const String websocketUrl = 'ws://192.168.0.1:81';
  static const Duration reconnectDelay = Duration(seconds: 3);
  static const int parkingSpaceCount = 4;
}
