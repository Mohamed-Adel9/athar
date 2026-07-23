import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/fetch_admin_dashboard_usecase.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._fetchAdminDashboardUseCase) : super(const AdminState());

  final FetchAdminDashboardUseCase _fetchAdminDashboardUseCase;

  Future<void> fetchDashboard() async {
    emit(state.copyWith(status: AdminStatus.loading, clearError: true));
    final result = await _fetchAdminDashboardUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (dashboard) => emit(
        state.copyWith(
          status: AdminStatus.success,
          dashboard: dashboard,
          clearError: true,
        ),
      ),
    );
  }
}
