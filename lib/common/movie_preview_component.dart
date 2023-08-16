import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/features/favourites/controller/favourites_controller.dart';
import 'package:mittarv/model/movies_model.dart';
import 'package:mittarv/theme/pallete.dart';

class MoviePreviewComponent extends ConsumerWidget {
  const MoviePreviewComponent({
    super.key,
    required this.size,
    required this.movie,
  });

  final Size size;
  final MoviesModel movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onLongPress: () {
        ref
            .read(favouritesControllerProvider.notifier)
            .addFavourite(context: context, movieId: movie.id);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: Pallete.whiteColor.withOpacity(0.2),
            // ),
            borderRadius: BorderRadius.circular(10),
          ),
          height: size.width * 0.6,
          width: size.width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.width * 0.6,
                width: size.width * 0.4,
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.6,
                      width: size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Pallete.whiteColor.withOpacity(0.2),
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            "$tmdbImageURL/${movie.posterPath}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '(${(movie.releaseDate != null) ? (movie.releaseDate?.toString().substring(0, 4)) : ""})',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Pallete.lightGreyColor,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 10,
                      width: size.width * 0.14,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return const Icon(
                            Icons.star,
                            size: 12,
                            color: Pallete.lightGreyColor,
                          );
                        },
                        itemCount: ((movie.voteAverage??1)/2).round(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
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
}
