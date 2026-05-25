import 'package:flutter_test/flutter_test.dart';
import 'package:smart_parking/features/parking/data/models/parking_update_mapper.dart';
import 'package:smart_parking/features/parking/domain/entities/gate_id.dart';
import 'package:smart_parking/features/parking/domain/entities/parking_update.dart';

void main() {
  const mapper = ParkingUpdateMapper();
  final now = DateTime(2026, 5, 25, 12);

  test('parses hello frame', () {
    final update = mapper.fromJson({'type': 'hello', 'status': 'connected'});
    expect(update, isA<HelloUpdate>());
  });

  test('parses parking event with since_ms', () {
    final update = mapper.fromJson(
      {'type': 'parking', 'id': 2, 'occupied': true, 'since_ms': 5000},
      now: now,
    );
    expect(update, isA<SpaceUpdate>());
    final space = (update! as SpaceUpdate).space;
    expect(space.id, 2);
    expect(space.occupied, isTrue);
    expect(
      space.occupiedSince,
      now.subtract(const Duration(milliseconds: 5000)),
    );
  });

  test('parses gate event', () {
    final update = mapper.fromJson({
      'type': 'gate',
      'gate': 'entry',
      'open': true,
    });
    expect(update, isA<GateUpdate>());
    final gate = (update! as GateUpdate).gate;
    expect(gate.id, GateId.entry);
    expect(gate.open, isTrue);
  });

  test('parses snapshot', () {
    final update = mapper.fromJson(
      {
        'type': 'snapshot',
        'spaces': [
          {'id': 1, 'occupied': false, 'since_ms': 0},
          {'id': 2, 'occupied': true, 'since_ms': 1000},
        ],
        'gates': {'entry': false, 'exit': true},
      },
      now: now,
    );
    expect(update, isA<SnapshotUpdate>());
    final snapshot = update! as SnapshotUpdate;
    expect(snapshot.spaces, hasLength(2));
    expect(snapshot.gates, hasLength(2));
    expect(snapshot.gates.firstWhere((g) => g.id == GateId.exit).open, isTrue);
  });

  test('returns null on unknown type', () {
    expect(mapper.fromJson({'type': 'something-else'}), isNull);
  });

  test('returns null on missing fields', () {
    expect(mapper.fromJson({'type': 'gate', 'gate': 'entry'}), isNull);
  });
}
