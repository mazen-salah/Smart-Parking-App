import 'package:equatable/equatable.dart';

class ParkingSpace extends Equatable {
  const ParkingSpace({
    required this.id,
    required this.occupied,
    this.occupiedSince,
  });

  final int id;
  final bool occupied;

  /// Wall-clock time the space first became occupied during the current session.
  /// `null` when the space is vacant.
  final DateTime? occupiedSince;

  Duration occupiedDuration(DateTime now) {
    if (!occupied || occupiedSince == null) return Duration.zero;
    return now.difference(occupiedSince!);
  }

  ParkingSpace copyWith({
    bool? occupied,
    DateTime? occupiedSince,
    bool clearOccupiedSince = false,
  }) {
    return ParkingSpace(
      id: id,
      occupied: occupied ?? this.occupied,
      occupiedSince:
          clearOccupiedSince ? null : (occupiedSince ?? this.occupiedSince),
    );
  }

  @override
  List<Object?> get props => [id, occupied, occupiedSince];
}
