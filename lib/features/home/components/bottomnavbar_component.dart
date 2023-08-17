import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/features/auth/controller/auth_controller.dart';
import 'package:mittarv/features/favourites/views/favourites_page.dart';
import 'package:mittarv/features/home/views/homepage.dart';
import 'package:mittarv/features/user/controller/user_controller.dart';
import 'package:mittarv/theme/pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBarView extends ConsumerStatefulWidget {
  const BottomNavBarView({super.key});

  @override
  ConsumerState<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends ConsumerState<BottomNavBarView> {
  int selectedIndex = 0;
  String expiryTimestamp = '';
  @override
  void initState() {
    super.initState();
    initializePreferences();
    checkExpiryAndPerformLogout();
    ref.read(userControllerProvider.notifier).getUser();
  }
  Future<void> initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    expiryTimestamp = prefs.getString('expiry') ?? '';
  }
  void checkExpiryAndPerformLogout() async {
    final expiryDateTime = DateTime.tryParse(expiryTimestamp.toString());
    if (expiryDateTime != null && DateTime.now().isAfter(expiryDateTime)) {
      ref.read(authControllerProvider.notifier).logout(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      const HomePageView(),
      const FavouritePageView(),
    ];
    var items = const [
      BottomNavigationBarItem(
        icon: Icon(OctIcons.home_fill_24),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(OctIcons.heart_fill_24),
        label: 'Likes',
      ),
    ];
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            pages[selectedIndex],
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBar(
                selectedItemColor: Pallete.whiteColor,
                unselectedItemColor: Colors.grey,
                backgroundColor: Pallete.backgroundColor.withOpacity(0.8),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: items,
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
