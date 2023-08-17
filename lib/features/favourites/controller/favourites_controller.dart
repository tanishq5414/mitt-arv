import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/features/movies/controllers/movie_controller.dart';
import 'package:mittarv/features/user/controller/user_controller.dart';
import 'package:mittarv/model/movies_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favouritesMovieProvider = StateProvider<List<MoviesModel>?>((ref) {
  return null;
});

final favouritesControllerProvider =
    StateNotifierProvider<FavouritesControllerNotifier, bool>((ref) {
  return FavouritesControllerNotifier(ref);
});

class FavouritesControllerNotifier extends StateNotifier<bool> {
  final Ref _ref;
  FavouritesControllerNotifier(this._ref) : super(false);

  Future<void> getFavourites({required context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favourites = [];
    final user = _ref.read(userDataProvider);
    if (user != null) {
      favourites = user.fav!;
    } else {
      favourites = prefs.getStringList('favourites') ?? [];
    }
    if(favourites.isEmpty){
      _ref.read(favouritesMovieProvider.notifier).update((state) => []);
      return;
    }
    final List<MoviesModel> movies = [];
      for (int i = 0; i < favourites.length; i++) {
        final movie = await _ref
            .read(movieControllerProvider.notifier)
            .getMovieDetails(context: context, movieId: favourites[i]);
        movies.add(
          MoviesModel(
            adult: movie.adult,
            backdropPath: movie.backdropPath,
            id: movie.id,
            originalLanguage: movie.originalLanguage,
            originalTitle: movie.originalTitle,
            overview: movie.overview,
            popularity: movie.popularity,
            posterPath: movie.posterPath,
            releaseDate: movie.releaseDate,
            title: movie.title,
            video: movie.video,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
          ),
        );
      final reversedmovies = movies.reversed;
      _ref
          .read(favouritesMovieProvider.notifier)
          .update((state) => reversedmovies.toList());
    }
  }

  Future<void> toggleFavourite({required context, required movieId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favourites = _ref.read(userDataProvider)?.fav?? prefs.getStringList('favourites') ?? [];
    
    if (favourites.contains(movieId.toString())) {
      favourites.remove(movieId.toString());
    } else {
      favourites.add(movieId.toString());
    }
    
    if (_ref.read(userDataProvider) != null) {
      _ref.read(userControllerProvider.notifier).updateFavorite(favourites);
    } else {
      prefs.setStringList('favourites', favourites);
    }
    
    await getFavourites(context: context);
  }
}
