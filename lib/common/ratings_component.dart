import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mittarv/theme/pallete.dart';

class BuildRatingsComponent extends StatelessWidget {
  const BuildRatingsComponent({
    super.key,
    required this.rating,
  });

  final num rating;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      onRatingUpdate: (v) {},
      ignoreGestures: true,
      initialRating: rating.toDouble(),
      direction: Axis.horizontal,
      itemSize: 15,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.zero,
      itemBuilder: (context, _) =>
          const Icon(
        size: 10,
        Icons.star,
        color: Pallete.whiteColor,
      ),
    );
  }
}
