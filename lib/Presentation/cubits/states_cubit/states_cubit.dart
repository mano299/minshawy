import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minshawy/Presentation/cubits/states_cubit/states_state.dart';
import '../../../data/hive_services.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit() : super(StatsInitial());

  void loadStats() {
    final listenedSurahs = HiveService.statsBox.get(
      'listened_surahs',
      defaultValue: <int>[],
    );

    emit(
      StatsLoaded(
        listenedSurahs.length,
      ),
    );
  }

  Future<void> addListenedSurah(int surahId) async {
    List listenedSurahs = HiveService.statsBox.get(
      'listened_surahs',
      defaultValue: <int>[],
    );

    if (!listenedSurahs.contains(surahId)) {
      listenedSurahs.add(surahId);

      await HiveService.statsBox.put(
        'listened_surahs',
        listenedSurahs,
      );

      loadStats();
    }
  }
}