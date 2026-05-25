import 'dart:async';

import '../../domain/entities/gate_id.dart';
import '../../domain/entities/parking_update.dart';
import '../../domain/repositories/parking_repository.dart';
import '../datasources/parking_websocket_datasource.dart';
import '../models/parking_update_mapper.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  ParkingRepositoryImpl({
    required ParkingWebSocketDataSource dataSource,
    ParkingUpdateMapper mapper = const ParkingUpdateMapper(),
  })  : _dataSource = dataSource,
        _mapper = mapper {
    _updateSubscription = _dataSource.messages
        .map(_mapper.fromJson)
        .where((u) => u != null)
        .cast<ParkingUpdate>()
        .listen(_updates.add);
  }

  final ParkingWebSocketDataSource _dataSource;
  final ParkingUpdateMapper _mapper;

  final StreamController<ParkingUpdate> _updates =
      StreamController<ParkingUpdate>.broadcast();
  late final StreamSubscription<ParkingUpdate> _updateSubscription;

  @override
  Stream<ParkingUpdate> get updates => _updates.stream;

  @override
  Stream<bool> get connectionStatus => _dataSource.connectionStatus;

  @override
  Future<void> connect() => _dataSource.connect();

  @override
  Future<void> disconnect() => _dataSource.disconnect();

  @override
  Future<void> requestSnapshot() => _dataSource.send({'type': 'refresh'});

  @override
  Future<void> setGateOpen(GateId gate, {required bool open}) {
    return _dataSource.send({
      'type': 'gate',
      'gate': gate.wireName,
      'open': open,
    });
  }

  Future<void> dispose() async {
    await _updateSubscription.cancel();
    await _updates.close();
    await _dataSource.dispose();
  }
}
