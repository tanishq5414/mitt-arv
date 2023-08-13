import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/model/movies_model.dart';
import 'package:mittarv/theme/pallete.dart';

class MoviePreviewComponent extends StatelessWidget {
  const MoviePreviewComponent({
    super.key,
    required this.size,
    required this.trendingMovies,
    required this.index,
  });

  final Size size;
  final int index;
  final List<MoviesModel> trendingMovies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius:
              BorderRadius.circular(10),
        ),
        height: size.width * 0.6,
        child: Stack(
          children: [
            SizedBox(
              height: size.width * 0.6,
              width: size.width * 0.9,
              child: Row(
                children: [
                  Container(
                    height: size.width * 0.6,
                    width: size.width * 0.86,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius
                              .circular(10),
                      image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(
                          "$tmdbImageURL/${trendingMovies[index].backdropPath}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: size.width * 0.14,
                width: size.width * 0.86,
                child: Stack(
                  children: [
                    Container(
                      height:
                          size.width * 0.14,
                      width:
                          size.width * 0.86,
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            const BorderRadius
                                .only(
                          bottomLeft:
                              Radius.circular(
                                  10),
                          bottomRight:
                              Radius.circular(
                                  10),
                        ),
                        color: Pallete
                            .backgroundColor
                            .withOpacity(0.8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 15,
                          bottom: 5
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${trendingMovies[
                                      index]
                                  .title!} (${trendingMovies[
                                          index]
                                      .releaseDate!.substring(0,4)})',
                              style: Theme.of(
                                      context)
                                  .textTheme
                                  .bodyLarge,
                            ),
                          ),
                          Text(
                            '${trendingMovies[index].voteAverage!} ⭐',
                            style: Theme.of(
                                    context)
                                .textTheme
                                .bodyLarge!.copyWith(
                                    color: Pallete
                                        .greenColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}