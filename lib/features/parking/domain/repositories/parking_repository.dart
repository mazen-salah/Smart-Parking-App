import '../entities/gate_id.dart';
import '../entities/parking_update.dart';

abstract class ParkingRepository {
  /// Resolves once the underlying transport has finished connecting (or fails).
  Future<void> connect();

  /// Closes the transport.
  Future<void> disconnect();

  /// Continuous stream of typed updates from the device.
  Stream<ParkingUpdate> get updates;

  /// Reports the current connection state. Emits `true` when connected.
  Stream<bool> get connectionStatus;

  /// Asks the device to set [gate] open/closed.
  Future<void> setGateOpen(GateId gate, {required bool open});

  /// Asks the device to re-send a full snapshot.
  Future<void> requestSnapshot();
}
