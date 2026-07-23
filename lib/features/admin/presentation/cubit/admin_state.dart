import 'package:equatable/equatable.dart';

import '../../data/models/admin_dashboard_model.dart';

enum AdminStatus { initial, loading, success, failure }

class AdminState extends Equatable {
  const AdminState({
    this.status = AdminStatus.initial,
    this.dashboard = const AdminDashboardModel(),
    this.errorMessage,
  });

  final AdminStatus status;
  final AdminDashboardModel dashboard;
  final String? errorMessage;

  AdminState copyWith({
    AdminStatus? status,
    AdminDashboardModel? dashboard,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AdminState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, dashboard, errorMessage];
}
