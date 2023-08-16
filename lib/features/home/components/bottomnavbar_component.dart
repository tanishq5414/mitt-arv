import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:mittarv/features/favourites/views/favourites_page.dart';
import 'package:mittarv/features/home/views/homepage.dart';
import 'package:mittarv/theme/pallete.dart';

class BottomNavBarView extends StatefulWidget {

   const BottomNavBarView({super.key});

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
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
