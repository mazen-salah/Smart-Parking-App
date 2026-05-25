import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_constants.dart';
import '../features/parking/data/datasources/parking_websocket_datasource.dart';
import '../features/parking/data/repositories/parking_repository_impl.dart';
import '../features/parking/domain/repositories/parking_repository.dart';
import '../features/parking/presentation/bloc/parking_bloc.dart';
import '../features/parking/presentation/pages/parking_home_page.dart';
import 'theme/app_theme.dart';

class SmartParkingApp extends StatelessWidget {
  const SmartParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ParkingRepository>(
      create: (_) => ParkingRepositoryImpl(
        dataSource:
            ParkingWebSocketDataSource(url: AppConstants.websocketUrl),
      ),
      child: BlocProvider<ParkingBloc>(
        create: (context) =>
            ParkingBloc(repository: context.read<ParkingRepository>())
              ..add(const ParkingStarted()),
        child: MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const ParkingHomePage(),
        ),
      ),
    );
  }
}
