import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/core/failure.dart';
import 'package:mittarv/core/type_defs.dart';
import 'package:mittarv/model/genre_model.dart';
import 'package:mittarv/model/movies_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dio = Dio();

//create provider
final moviesApiProvider = Provider((ref) {
  return MoviesApi();
});

abstract class IMoviesApi {
  FutureEither<List<MoviesModel>> getTopRatedMovies({required page});
  FutureEither<List<MoviesModel>> searchMoviesByQuery({required query});
  FutureEither<List<GenreModel>> getGenreList();
  FutureEither<ImageProvider> loadImage(String imagePath);
}

class MoviesApi implements IMoviesApi {
  @override
  FutureEither<List<MoviesModel>> getTopRatedMovies({required page}) async {
    try {
      dio.options.headers['Authorization'] = tmdbacessToken;
      dio.options.queryParameters['page'] = page;
      final data = await dio.get('$tmdbAPIURL/movie/top_rated');
      final List<MoviesModel> movies = [];
      data.data['results'].forEach((element) {
        movies.add(MoviesModel.fromJson(element));
      });
      return right(movies);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<MoviesModel>> searchMoviesByQuery({required query}) async {
    try {
      dio.options.headers['Authorization'] = tmdbacessToken;
      dio.options.queryParameters['query'] = query;
      dio.options.queryParameters['page'] = 1;
      final data = await dio.get('$tmdbAPIURL/search/movie');
      final List<MoviesModel> movies = [];
      data.data['results'].forEach((element) {
        movies.add(MoviesModel.fromJson(element));
      });
      return right(movies);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<GenreModel>> getGenreList() async {
    try {
      dio.options.headers['Authorization'] = tmdbacessToken;
      final data = await dio.get('$tmdbAPIURL/genre/movie/list');
      final List<GenreModel> movies = [];
      data.data['genres'].forEach((element) {
        movies.add(GenreModel.fromJson(element));
      });
      return right(movies);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<ImageProvider> loadImage(String imagePath) async {
    try {
      final data =
          await NetworkAssetBundle(Uri.parse('$tmdbImageURL$imagePath'))
              .load('');
      return right(MemoryImage(data.buffer.asUint8List()));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
