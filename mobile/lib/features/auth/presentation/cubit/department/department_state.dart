import 'package:dar_care/features/auth/domain/entities/department.dart';
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
  final List<Department> departments;

  const DepartmentLoaded(this.departments);

  @override
  List<Object> get props => [departments];
}

class DepartmentError extends DepartmentState {
  final String messageKey;

  const DepartmentError(this.messageKey);

  @override
  List<Object> get props => [messageKey];
}
