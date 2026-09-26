import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muwaqqit/core/theme/app_theme.dart';
import 'package:muwaqqit/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:muwaqqit/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:muwaqqit/features/dashboard/presentation/screens/dashboard_screen.dart';

class Muwaqqit extends StatelessWidget {
  const Muwaqqit({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => DashboardCubit(repository: DashboardRepositoryImpl()),
    child: MaterialApp(debugShowCheckedModeBanner: false, home: const DashboardScreen(), theme: AppTheme.light, title: 'Muwaqqit'),
  );
}
