import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../bloc/parking_bloc.dart';
import '../widgets/connection_status_card.dart';
import '../widgets/gate_control_panel.dart';
import '../widgets/parking_grid.dart';
import '../widgets/section_header.dart';

class ParkingHomePage extends StatefulWidget {
  const ParkingHomePage({super.key});

  @override
  State<ParkingHomePage> createState() => _ParkingHomePageState();
}

class _ParkingHomePageState extends State<ParkingHomePage> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () =>
                context.read<ParkingBloc>().add(const ParkingRefreshRequested()),
          ),
        ],
      ),
      body: BlocConsumer<ParkingBloc, ParkingBlocState>(
        listenWhen: (prev, curr) => prev.lastError != curr.lastError && curr.lastError != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.lastError!)));
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => context
                .read<ParkingBloc>()
                .add(const ParkingRefreshRequested()),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ConnectionStatusCard(connected: state.connected),
                const SizedBox(height: 16),
                const SectionHeader('Parking bays', icon: Icons.local_parking),
                ParkingGrid(spaces: state.spaces, now: _now),
                const SizedBox(height: 16),
                const SectionHeader('Gates', icon: Icons.door_sliding),
                GateControlPanel(
                  gates: state.gates,
                  connected: state.connected,
                  onToggle: (gate, open) => context
                      .read<ParkingBloc>()
                      .add(ParkingGateToggled(gate: gate, open: open)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
