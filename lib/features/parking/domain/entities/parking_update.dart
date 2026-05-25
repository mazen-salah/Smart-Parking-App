import 'package:equatable/equatable.dart';

import 'gate.dart';
import 'parking_space.dart';

/// A single update emitted by the device.
sealed class ParkingUpdate extends Equatable {
  const ParkingUpdate();
}

class HelloUpdate extends ParkingUpdate {
  const HelloUpdate();
  @override
  List<Object?> get props => const [];
}

class SnapshotUpdate extends ParkingUpdate {
  const SnapshotUpdate({required this.spaces, required this.gates});
  final List<ParkingSpace> spaces;
  final List<Gate> gates;
  @override
  List<Object?> get props => [spaces, gates];
}

class SpaceUpdate extends ParkingUpdate {
  const SpaceUpdate(this.space);
  final ParkingSpace space;
  @override
  List<Object?> get props => [space];
}

class GateUpdate extends ParkingUpdate {
  const GateUpdate(this.gate);
  final Gate gate;
  @override
  List<Object?> get props => [gate];
}
