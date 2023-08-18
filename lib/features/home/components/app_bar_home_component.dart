import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/features/auth/controller/auth_controller.dart';
import 'package:mittarv/features/auth/view/signup_page_view.dart';
import 'package:mittarv/features/search/search_page_view.dart';
import 'package:mittarv/model/user_model.dart';
import 'package:mittarv/theme/pallete.dart';

AppBar appBarHomeComponent(BuildContext context, UserModel? user, WidgetRef ref, Color color) {
    return AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              SizedBox(
                width: 55,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Pallete.blueColor,
                      ),
                      height: 20,
                      width: 18,
                    ),
                    Positioned(
                      left: 16,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Pallete.orangeColor,
                        ),
                        height: 20,
                        width: 18,
                      ),
                    ),
                    Positioned(
                      left: 16 * 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Pallete.greenColor,
                        ),
                        height: 20,
                        width: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Text('Postalboxd',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
            ],
          ),
        ),
        backgroundColor: color,
        actions: [
          IconButton(
            iconSize: 30,
            style: IconButton.styleFrom(
              backgroundColor: Pallete.whiteColor,
              shape: const CircleBorder(),
            ),
            onPressed: () {
              Navigator.push(
                context,
                SearchPageView.route(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (user == null) {
                Navigator.push(
                  context,
                  SignUpPageView.route(),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Pallete.backgroundColor,
                      title: Text('Logout',
                          style: Theme.of(context).textTheme.titleMedium!),
                      content: Text('Are you sure you want to log out?',
                          style: Theme.of(context).textTheme.bodyMedium!),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(authControllerProvider.notifier).logout(
                                  context: context,
                                );
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: (user != null)
                    ? Pallete.deepPurpleColor
                    : Pallete.lightGreyColor,
                child: (user != null)
                    ? Container(
                        decoration: BoxDecoration(
                          color: Pallete.deepPurpleColor,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              user.profilePic ?? '',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      );
  }
