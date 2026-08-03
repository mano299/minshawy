import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/hive_services.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial());

  void loadFavorites() {
    emit(
      FavoritesLoaded(
        HiveService.favoritesBox.values.toList(),
      ),
    );
  }

  Future<void> toggleFavorite(int surahId) async {
    if (isFavorite(surahId)) {
      await HiveService.favoritesBox.delete(
        surahId,
      );
    } else {
      await HiveService.favoritesBox.put(
        surahId,
        surahId,
      );
    }

    loadFavorites();
  }

  bool isFavorite(int surahId) {
    return HiveService.favoritesBox.containsKey(
      surahId,
    );
  }
}