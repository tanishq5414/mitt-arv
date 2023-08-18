import 'package:flutter/material.dart';

class Commons{
    static SliverGridDelegateWithFixedCrossAxisCount tabletGridDelegate(Size size) {
    return const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.56,
                                  crossAxisSpacing: 15,
                                );
  }
    static SliverGridDelegateWithFixedCrossAxisCount phoneGridDelegate(Size size) {
    return const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.56,
                                  crossAxisSpacing: 15,
                                );
  }
  static SliverGridDelegateWithFixedCrossAxisCount desktopGridDelegate(Size size) {
    return const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 9,
                                  childAspectRatio: 0.56,
                                  crossAxisSpacing: 15,
                                );
  }
}