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
    var favourites = [];
    final user = _ref.read(userDataProvider);
    if (user != null) {
      favourites = user.fav!;
    } else {
      favourites = prefs.getStringList('favourites') ?? [];
    }
    final List<MoviesModel> movies = [];
    if (favourites.isNotEmpty) {
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
      }
      final reversedmovies = movies.reversed;
      _ref
          .read(favouritesMovieProvider.notifier)
          .update((state) => reversedmovies.toList());
    }
    
  }

  Future<void> addFavourite({required context, required movieId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favourites = prefs.getStringList('favourites');
    final user = _ref.read(userDataProvider);
    if (favourites != null) {
      if (!favourites.contains(movieId.toString())) {
        favourites.add(movieId.toString());
        prefs.setStringList('favourites', favourites);
      }
    } else {
      prefs.setStringList('favourites', [movieId.toString()]);
    }
    if (user != null) {
      var fav = prefs.getStringList('favourites');
      _ref.read(userControllerProvider.notifier).updateFavorite(fav!);
    }
    getFavourites(context: context);
  }

  Future<void> removeFavourite({required context, required movieId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favourites = prefs.getStringList('favourites');
    if (favourites != null) {
      if (favourites.contains(movieId.toString())) {
        favourites.remove(movieId.toString());
        prefs.setStringList('favourites', favourites);
      }
    }
    final user = _ref.read(userDataProvider);
    if (user != null) {
      var fav = prefs.getStringList('favourites');
      _ref.read(userControllerProvider.notifier).updateFavorite(fav!);
    }
    getFavourites(context: context);
  }
}
