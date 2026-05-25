import 'package:flutter/material.dart';

import '../../domain/entities/parking_space.dart';
import 'parking_space_card.dart';

class ParkingGrid extends StatelessWidget {
  const ParkingGrid({
    required this.spaces,
    required this.now,
    super.key,
  });

  final List<ParkingSpace> spaces;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: spaces
              .map((s) => ParkingSpaceCard(space: s, now: now))
              .toList(growable: false),
        );
      },
    );
  }
}
