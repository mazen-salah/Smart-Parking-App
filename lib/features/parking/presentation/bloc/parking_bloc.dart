import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/gate.dart';
import '../../domain/entities/gate_id.dart';
import '../../domain/entities/parking_space.dart';
import '../../domain/entities/parking_update.dart';
import '../../domain/repositories/parking_repository.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingBlocEvent, ParkingBlocState> {
  ParkingBloc({required ParkingRepository repository})
      : _repository = repository,
        super(ParkingBlocState.initial()) {
    on<ParkingStarted>(_onStarted);
    on<ParkingRefreshRequested>(_onRefreshRequested);
    on<ParkingGateToggled>(_onGateToggled);
    on<_ParkingConnectionChanged>(_onConnectionChanged);
    on<_ParkingUpdateReceived>(_onUpdateReceived);
  }

  final ParkingRepository _repository;
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<ParkingUpdate>? _updateSub;
  Timer? _reconnectTimer;

  Future<void> _onStarted(
    ParkingStarted event,
    Emitter<ParkingBlocState> emit,
  ) async {
    _connectionSub ??= _repository.connectionStatus
        .listen((c) => add(_ParkingConnectionChanged(c)));
    _updateSub ??= _repository.updates
        .listen((u) => add(_ParkingUpdateReceived(u)));
    await _connect(emit);
  }

  Future<void> _onRefreshRequested(
    ParkingRefreshRequested event,
    Emitter<ParkingBlocState> emit,
  ) async {
    if (!state.connected) {
      await _connect(emit);
      return;
    }
    try {
      await _repository.requestSnapshot();
    } catch (e) {
      emit(state.copyWith(lastError: e.toString()));
    }
  }

  Future<void> _onGateToggled(
    ParkingGateToggled event,
    Emitter<ParkingBlocState> emit,
  ) async {
    // Optimistic update — server will echo confirmation.
    final updatedGates = state.gates
        .map((g) => g.id == event.gate ? g.copyWith(open: event.open) : g)
        .toList(growable: false);
    emit(state.copyWith(gates: updatedGates, clearError: true));

    try {
      await _repository.setGateOpen(event.gate, open: event.open);
    } catch (e) {
      emit(state.copyWith(lastError: e.toString()));
    }
  }

  void _onConnectionChanged(
    _ParkingConnectionChanged event,
    Emitter<ParkingBlocState> emit,
  ) {
    emit(state.copyWith(connected: event.connected, clearError: event.connected));
    if (event.connected) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    } else {
      _scheduleReconnect();
    }
  }

  void _onUpdateReceived(
    _ParkingUpdateReceived event,
    Emitter<ParkingBlocState> emit,
  ) {
    switch (event.update) {
      case HelloUpdate():
        return;
      case SnapshotUpdate(:final spaces, :final gates):
        emit(state.copyWith(spaces: spaces, gates: gates));
      case SpaceUpdate(:final space):
        final next = state.spaces
            .map((s) => s.id == space.id ? space : s)
            .toList(growable: false);
        emit(state.copyWith(spaces: next));
      case GateUpdate(:final gate):
        final next = state.gates
            .map((g) => g.id == gate.id ? gate : g)
            .toList(growable: false);
        emit(state.copyWith(gates: next));
    }
  }

  Future<void> _connect(Emitter<ParkingBlocState> emit) async {
    try {
      await _repository.connect();
    } catch (e) {
      emit(state.copyWith(lastError: e.toString()));
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(AppConstants.reconnectDelay, () {
      if (!isClosed) add(const ParkingRefreshRequested());
    });
  }

  @override
  Future<void> close() async {
    _reconnectTimer?.cancel();
    await _connectionSub?.cancel();
    await _updateSub?.cancel();
    await _repository.disconnect();
    await super.close();
  }
}
