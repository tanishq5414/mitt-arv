import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/core/core.dart';
import 'package:mittarv/model/user_model.dart';

var dio = Dio();
final userAPIProvider = Provider((ref) {
  return UserAPI();
});

abstract class IUserAPI {
  FutureEither<UserModel> getUser(
      {required String userId, required String token});

  FutureEither<void> updateFavorite(
      {required String userId, required String token, required List<String> favourites});

}

class UserAPI implements IUserAPI {
  @override
  FutureEither<UserModel> getUser(
      {required String userId, required String token}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      var response = await dio.get('$authAPIURL/test/user/$userId');
      return right(UserModel.fromJson(response.data));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> updateFavorite(
      {required String userId, required String token, required List<String> favourites}) async {
    try {
      dio.options.headers['x-access-token'] = token;
      await dio.put('$authAPIURL/test/user/fav/$userId', data: {
        "favs": favourites
      });
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
