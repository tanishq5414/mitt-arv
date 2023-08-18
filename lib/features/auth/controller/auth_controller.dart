import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/apis/auth_api.dart';
import 'package:mittarv/core/core.dart';
import 'package:mittarv/features/auth/view/signin_page_view.dart';
import 'package:mittarv/features/home/components/bottom_nav_bar_component.dart';
import 'package:mittarv/features/user/controller/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  return AuthControllerNotifier(ref, authAPI);
});

class AuthControllerNotifier extends StateNotifier<bool> {
  Ref ref;
  final AuthApi authApi;
  AuthControllerNotifier(
    this.ref,
    this.authApi,
  ) : super(false);

  void login(
      {required context,
      required String username,
      required String password}) async {
    try {
      final res = await authApi.login(username: username, password: password);
      res.fold((l) => showSnackBar(context, l.message), (r) async {
        ref.read(userDataProvider.notifier).update((state) => r);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', r.accessToken ?? '');
        prefs.setString('userId', r.id ?? '');
        prefs.setString('expiry',
            DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch.toString());
        Navigator.of(context).popUntil((route) => false);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BottomNavBarView()));
      });
    } catch (e) {
      // print(e);
    }
  }

  void register(
      {required context,
      required String username,
      required String password,
      required String email}) async {
    try {
      final res = await authApi.register(
          username: username, password: password, email: email);
      res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => {
                showSnackBar(
                    context, 'Registration successful you can sign in now'),
                Navigator.of(context).push(SignInPageView.route())
              });
    } catch (e) {
      // print(e);
    }
  }

  void logout({required context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('expiry');
      ref.read(userDataProvider.notifier).update((state) => null);
      Navigator.of(context).popUntil((route) => false);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BottomNavBarView()));
    } catch (e) {
      // print(e);
    }
  }
}
