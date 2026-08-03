abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<int> favoriteIds;

  FavoritesLoaded(this.favoriteIds);
}

class FavoritesEmpty extends FavoritesState{

}