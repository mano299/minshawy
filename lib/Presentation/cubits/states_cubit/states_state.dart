abstract class StatsState {}

class StatsInitial extends StatsState {}

class StatsLoaded extends StatsState {
  final int listenedCount;

  StatsLoaded(this.listenedCount);
}