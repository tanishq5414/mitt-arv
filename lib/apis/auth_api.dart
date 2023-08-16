import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/core/core.dart';
import 'package:mittarv/model/user_model.dart';

final authAPIProvider = Provider((ref) {
  return AuthApi();
});

abstract class IAuthApi {
  FutureEither<UserModel> login(
      {required String username, required String password});
  FutureEither<void> register(
      {required String username,
      required String password,
      required String email});
}

final dio = Dio();

class AuthApi implements IAuthApi {
  @override
  FutureEither<UserModel> login(
      {required String username, required String password}) async {
    try {
      var res = await dio.post('$authAPIURL/auth/signin',
          data: {'username': username, 'password': password});
      return right(UserModel.fromJson(res.data));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<void> register(
      {required String email,
      required String password,
      required String username}) async {
    try {
      await dio.post('$authAPIURL/auth/signup',
          data: {'username': username, 'password': password, 'email': email});
      return right(null);
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
