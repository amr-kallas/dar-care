import 'package:dar_care/features/auth/data/models/app_department.dart';
import 'package:equatable/equatable.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object> get props => [];
}

class DepartmentInitial extends DepartmentState {
  const DepartmentInitial();
}

class DepartmentLoading extends DepartmentState {
  const DepartmentLoading();
}

class DepartmentLoaded extends DepartmentState {
  final List<AppDepartment> departments;

  const DepartmentLoaded(this.departments);

  @override
  List<Object> get props => [departments];
}

class DepartmentError extends DepartmentState {
  final String message;

  const DepartmentError(this.message);

  @override
  List<Object> get props => [message];
}

