import 'package:flutter/material.dart';
import 'package:mittarv/theme/pallete.dart';

AppBar customAppBar({required BuildContext context, List<Widget>? actions}) {
   return AppBar(
    actions: actions,
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
    backgroundColor: Colors.transparent,
  );
}
