import 'package:muwaqqit/features/dashboard/domain/entities/dashboard_snapshot.dart';

abstract class DashboardRepository {
  Future<DashboardSnapshot> load();

  DashboardSnapshot refresh();
}
