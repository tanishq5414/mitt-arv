import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/apis/user_api.dart';
import 'package:mittarv/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userDataProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final userControllerProvider =
    StateNotifierProvider<UserControllerNotifier, bool>((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return UserControllerNotifier(userAPI, ref);
});

class UserControllerNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final UserAPI _userAPI;
  UserControllerNotifier(
    this._userAPI,
    this._ref,
  ) : super(false);

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? "";
    var userId = prefs.getString('userId') ?? "";
    if (token == "" || userId == "") {
      return;
    }
    final res = await _userAPI.getUser(userId: userId, token: token);
    res.fold((l) => null, (r) {
       _ref.read(userDataProvider.notifier).update((state) => r);
    });
  }
}
