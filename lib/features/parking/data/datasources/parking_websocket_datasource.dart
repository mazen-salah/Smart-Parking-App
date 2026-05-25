import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ParkingWebSocketDataSource {
  ParkingWebSocketDataSource({required this.url});

  final String url;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  final StreamController<Map<String, dynamic>> _messages =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<bool> _connection =
      StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messages.stream;
  Stream<bool> get connectionStatus => _connection.stream;

  bool _connected = false;
  bool get isConnected => _connected;

  Future<void> connect() async {
    await disconnect();
    try {
      final channel = IOWebSocketChannel.connect(Uri.parse(url));
      _channel = channel;
      _subscription = channel.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: true,
      );
      _setConnected(true);
    } catch (e) {
      _setConnected(false);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _setConnected(false);
  }

  Future<void> send(Map<String, dynamic> message) async {
    final channel = _channel;
    if (channel == null || !_connected) {
      throw StateError('WebSocket is not connected.');
    }
    channel.sink.add(jsonEncode(message));
  }

  void _onData(dynamic raw) {
    if (raw is! String) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        _messages.add(decoded);
      }
    } on FormatException {
      // Ignore malformed frames.
    }
  }

  void _onError(Object _) {
    _setConnected(false);
  }

  void _onDone() {
    _setConnected(false);
  }

  void _setConnected(bool value) {
    if (_connected == value) return;
    _connected = value;
    _connection.add(value);
  }

  Future<void> dispose() async {
    await disconnect();
    await _messages.close();
    await _connection.close();
  }
}
