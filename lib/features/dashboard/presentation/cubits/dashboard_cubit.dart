import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:muwaqqit/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardCubit extends Cubit<DashboardSnapshot?> {
  final DashboardRepository _repository;

  Timer? _timer;

  DashboardCubit({required DashboardRepository repository}) : _repository = repository, super(null) {
    _init();
  }

  Future<void> _init() async {
    final snapshot = await _repository.load();
    if (isClosed) return;
    emit(snapshot);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => emit(_repository.refresh()));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
