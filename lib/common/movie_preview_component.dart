
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/common/ratings_component.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/features/favourites/controller/favourites_controller.dart';
import 'package:mittarv/features/movies/views/moviepage.dart';
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
    return SizedBox(
      width: size.width * 0.4,
      height: size.width * 0.6,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MoviePageView(
                        movie: movie,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            decoration: BoxDecoration(
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
                            image: NetworkImage(
                              "$posterTmdbImageUrl/${movie.posterPath}",
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
                      BuildRatingsComponent(
                        rating: (movie.voteAverage ?? 1) / 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
