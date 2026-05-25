part of 'parking_bloc.dart';

class ParkingBlocState extends Equatable {
  const ParkingBlocState({
    required this.connected,
    required this.spaces,
    required this.gates,
    this.lastError,
  });

  factory ParkingBlocState.initial() {
    final spaces = List<ParkingSpace>.generate(
      AppConstants.parkingSpaceCount,
      (i) => ParkingSpace(id: i + 1, occupied: false),
    );
    final gates = GateId.values
        .map((id) => Gate(id: id, open: false))
        .toList(growable: false);
    return ParkingBlocState(
      connected: false,
      spaces: spaces,
      gates: gates,
    );
  }

  final bool connected;
  final List<ParkingSpace> spaces;
  final List<Gate> gates;
  final String? lastError;

  Gate gateById(GateId id) => gates.firstWhere((g) => g.id == id);

  ParkingBlocState copyWith({
    bool? connected,
    List<ParkingSpace>? spaces,
    List<Gate>? gates,
    String? lastError,
    bool clearError = false,
  }) {
    return ParkingBlocState(
      connected: connected ?? this.connected,
      spaces: spaces ?? this.spaces,
      gates: gates ?? this.gates,
      lastError: clearError ? null : (lastError ?? this.lastError),
    );
  }

  @override
  List<Object?> get props => [connected, spaces, gates, lastError];
}
