

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mittarv/common/common.dart';
import 'package:mittarv/common/movie_preview_component.dart';
import 'package:mittarv/common/ratings_component.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/features/home/components/app_bar_home_component.dart';
import 'package:mittarv/features/movies/controllers/movies_controller.dart';
import 'package:mittarv/features/user/controller/user_controller.dart';
import 'package:mittarv/model/genre_model.dart';
import 'package:mittarv/model/movies_model.dart';
import 'package:mittarv/theme/pallete.dart';

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<HomePageView> {
  int page = 0;
  late List<MoviesModel> trendingMovies = [];
  final ScrollController _scrollController = ScrollController();
  num _scrollPosition = 0;
  double backgroundOpacity = 0;
  bool isLoading = false;
  //generate random number for bannerIndex
  final int bannerIndex = Random().nextInt(10);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollListener();
    });
    ref.read(movieControllerProvider.notifier).getGenreList(context: context);
    _loadMore();
  }

  void _scrollListener() {
    _scrollPosition = _scrollController.position.pixels;
    double opacity = _scrollPosition / 300;
    opacity = opacity.clamp(0, 1);
    setState(() {
      backgroundOpacity = opacity;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      isLoading = true;
    });
    page++;
    if (context.mounted) {
      await ref
          .read(movieControllerProvider.notifier)
          .getTopRatedMovies(context: context, page: page);
      final newMovies = ref.read(trendingMoviesProvider) ?? [];
      setState(() {
        trendingMovies.addAll(newMovies);
        trendingMovies.removeWhere((element) => element.backdropPath == null);
        trendingMovies.removeWhere((element) => element.posterPath == null);
        trendingMovies.removeWhere((element) => element.title == null);
        trendingMovies.removeWhere(
            (element) => element.genreIds == null || element.genreIds!.isEmpty);
        // _generatePalette();

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var genreList = ref.watch(genreListProvider);
    var user = ref.watch(userDataProvider);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBarHomeComponent(
            context,
            user,
            ref,
            (_scrollPosition < 100)
                ? Colors.transparent
                : Pallete.backgroundColor),
        body: Stack(
          children: [
            (trendingMovies.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      bannerHomeComponent(size, context, genreList),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: LazyLoadScrollView(
                          scrollOffset: 500,
                          isLoading:
                              isLoading, // Set the loading indicator state here
                          onEndOfPage: () => _loadMore(),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.4,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Top Rated Films',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontSize: 22,
                                          )),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                GridView.builder(
                                  gridDelegate: (size.width > 1400)
                                      ? Commons.desktopGridDelegate(size)
                                      : (size.width > 650 && size.width < 1400)
                                          ? Commons.tabletGridDelegate(size)
                                          : Commons.phoneGridDelegate(size),
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: trendingMovies.length,
                                  itemBuilder: (context, position) {
                                    return MoviePreviewComponent(
                                        size: size,
                                        movie: trendingMovies[position]);
                                  },
                                ),
                                if (isLoading)
                                  const Center(
                                      child: CircularProgressIndicator(
                                    color: Pallete.whiteColor,
                                  )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        floatingActionButton: (_scrollPosition > 500)
            ? Container(
                margin: EdgeInsets.only(bottom: size.height * 0.06),
                child: FloatingActionButton(
                  backgroundColor: Pallete.greyColor,
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Pallete.whiteColor,
                  ),
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              )
            : null,
      ),
    );
  }

  Column bannerHomeComponent(Size size, BuildContext context, List<GenreModel>? genreList) {
    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: (size.width > 600)
                                  ? size.height * 0.3
                                  : size.height * 0.3,
                              width: size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    "$backdropTmdbImageUrl/${trendingMovies[bannerIndex].backdropPath}",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.3,
                              width: size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Pallete.backgroundColor.withOpacity(0.5),
                                    Pallete.backgroundColor,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.3,
                              width: size.width,
                              color: Pallete.backgroundColor
                                  .withOpacity(backgroundOpacity),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${trendingMovies[bannerIndex].title} ${trendingMovies[bannerIndex].releaseDate != null ? '(${trendingMovies[bannerIndex].releaseDate!.toString().substring(0, 4)})' : ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: Pallete.whiteColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${genreList?.firstWhere((element) => element.id == trendingMovies[bannerIndex].genreIds?[0]).name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Pallete.lightGreyColor,
                                            ),
                                      ),
                                      BuildRatingsComponent(
                                        rating: (trendingMovies[bannerIndex]
                                                    .voteAverage ??
                                                1) /
                                            2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: size.height * 0.2,
                              width: size.width,
                              color: Pallete.backgroundColor
                                  .withOpacity(backgroundOpacity),
                            ),
                          ],
                        ),
                      ],
                    );
  }
}
