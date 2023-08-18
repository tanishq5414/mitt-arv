import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/common/appbar_component.dart';
import 'package:mittarv/features/auth/controller/auth_controller.dart';
import 'package:mittarv/features/auth/view/signup_page_view.dart';

class SignInPageView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const SignInPageView());
  const SignInPageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageViewState();
}

class _SignInPageViewState extends ConsumerState<SignInPageView> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'Sign in to continue!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                  decoration: inputDecoration('Username'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  decoration: inputDecoration('Password'),
                  obscureText: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(authControllerProvider.notifier).login(
                            context: context,
                            username: usernameController.text,
                            password: passwordController.text);
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, SignUpPageView.route());
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      border: const OutlineInputBorder(),
    );
  }
}
