part of 'suras_cubit.dart';

@immutable
sealed class SurasState {}

final class SurasInitial extends SurasState {}

final class SurasLoading extends SurasState {}

final class SurasSuccess extends SurasState {
  final List<SurahModel> suras;

  SurasSuccess(this.suras);
}

final class SurasError extends SurasState {
  final String errorMessage;

  SurasError(this.errorMessage);
}
