import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPageView extends ConsumerStatefulWidget {
  const SignUpPageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends ConsumerState<SignUpPageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: const Center(
        child: Text('Sign Up Page'),
      ),
    );
  }
}