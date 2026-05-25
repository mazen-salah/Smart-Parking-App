part of 'parking_bloc.dart';

sealed class ParkingBlocEvent extends Equatable {
  const ParkingBlocEvent();
  @override
  List<Object?> get props => const [];
}

class ParkingStarted extends ParkingBlocEvent {
  const ParkingStarted();
}

class ParkingRefreshRequested extends ParkingBlocEvent {
  const ParkingRefreshRequested();
}

class ParkingGateToggled extends ParkingBlocEvent {
  const ParkingGateToggled({required this.gate, required this.open});
  final GateId gate;
  final bool open;
  @override
  List<Object?> get props => [gate, open];
}

class _ParkingConnectionChanged extends ParkingBlocEvent {
  const _ParkingConnectionChanged(this.connected);
  final bool connected;
  @override
  List<Object?> get props => [connected];
}

class _ParkingUpdateReceived extends ParkingBlocEvent {
  const _ParkingUpdateReceived(this.update);
  final ParkingUpdate update;
  @override
  List<Object?> get props => [update];
}
