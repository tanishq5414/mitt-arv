// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/common/ratings_component.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/features/favourites/controller/favourites_controller.dart';

import 'package:mittarv/model/movies_model.dart';
import 'package:mittarv/theme/pallete.dart';

class MovieDetailPageView extends ConsumerStatefulWidget {
  final MoviesModel? movie;
  const MovieDetailPageView({
    super.key,
    required this.movie,
  });

  @override
  ConsumerState<MovieDetailPageView> createState() => _MoviePageViewState();
}

class _MoviePageViewState extends ConsumerState<MovieDetailPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkFavourite();
    });
  }

  bool isFavourited = false;

  void toggleFavourite() {
    if (isFavourited) {
      removeFromFavourites();
    } else {
      addToFavourites();
    }
  }

  void addToFavourites() {
    ref.read(favouritesControllerProvider.notifier).addFavourite(
          context: context,
          movieId: widget.movie!.id,
        );
    setState(() {
      isFavourited = true;
    });
  }

  void removeFromFavourites() {
    ref.read(favouritesControllerProvider.notifier).removeFavourite(
          context: context,
          movieId: widget.movie!.id,
        );
    setState(() {
      isFavourited = false;
    });
  }

  void checkFavourite() {
    final favourites = ref.read(favouritesMovieProvider);
    if (favourites != null) {
      for (int i = 0; i < favourites.length; i++) {
        if (favourites[i].id == widget.movie!.id) {
          setState(() {
            isFavourited = true;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.deepBlueColor,
          title: Text(widget.movie!.title ?? '',
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis),
        ),
        // extendBodyBehindAppBar: true,
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.3,
              child: Image.network(
                '$backdropTmdbImageUrl/${widget.movie!.backdropPath}',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.05,
                ),
                Container(
                  height: size.height * 0.2,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        "$posterTmdbImageUrl/${widget.movie!.posterPath}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.6,
                      child: Text(
                        widget.movie!.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      child: Text(
                        "(${widget.movie!.releaseDate?.substring(0, 4) ?? ''})",
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    BuildRatingsComponent(
                      rating: (widget.movie?.voteAverage ?? 1) / 2,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    (isFavourited)
                        ? IconButton(
                            onPressed: () {
                              removeFromFavourites();
                            },
                            icon: const Icon(
                              OctIcons.heart_fill_16,
                              color: Pallete.whiteColor,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              addToFavourites();
                            },
                            icon: const Icon(OctIcons.heart_24,
                                color: Pallete.whiteColor)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: size.width * 0.9,
                child: Text(
                  widget.movie!.overview ?? '',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Pallete.lightGreyColor,
                      ),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ));
  }
}
