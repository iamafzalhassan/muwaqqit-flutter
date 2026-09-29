import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:muwaqqit/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardCubit extends Cubit<DashboardSnapshot?> {
  final DashboardRepository _repository;

  final Duration _retryDelay;

  Timer? _timer;

  DashboardCubit({required DashboardRepository repository, Duration retryDelay = const Duration(seconds: 5)}) : _repository = repository, _retryDelay = retryDelay, super(null) {
    _init();
  }

  Future<void> _init() async {
    try {
      final snapshot = await _repository.load();
      if (isClosed) return;
      emit(snapshot);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => emit(_repository.refresh()));
    } catch (_) {
      if (!isClosed) _timer = Timer(_retryDelay, _init);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
