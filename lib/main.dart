import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/features/home/components/bottomnavbar_component.dart';
import 'package:mittarv/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        title: 'MittaRV',
        theme: AppTheme.theme,
        home: const BottomNavBarView(),
      ),
    );
  }
}
