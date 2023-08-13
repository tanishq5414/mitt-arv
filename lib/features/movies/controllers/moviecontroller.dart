import 'package:mittarv/apis/movies_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/core/core.dart';
import 'package:mittarv/model/movies_model.dart';

final trendingMoviesProvider = StateProvider<List<MoviesModel>?>((ref) {
  return null;
});

final searchMoviesProvider = StateProvider<List<MoviesModel>?>((ref) {
  return null;
});

final movieControllerProvider =
    StateNotifierProvider<MovieControllerNotifier, bool>((ref) {
  final moviesApi = ref.watch(moviesApiProvider);
  return MovieControllerNotifier(moviesApi, ref);
});

class MovieControllerNotifier extends StateNotifier<bool> {
  final MoviesApi _moviesApi;
  final Ref _ref;
  MovieControllerNotifier(this._moviesApi, this._ref) : super(false);

  Future<void> getTopRatedMovies({required context, required page}) async {
    Future.delayed(const Duration(seconds: 10));
    final res = await _moviesApi.getTopRatedMovies(page: page);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(trendingMoviesProvider.notifier).update((state) => r);
    });
  }

  Future<void> searchMoviesByQuery({required context, required query}) async {
    final res = await _moviesApi.searchMoviesByQuery(query: query);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(searchMoviesProvider.notifier).update((state) => r);
    });
  }
}
