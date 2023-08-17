// ignore_for_file: unused_import

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mittarv/common/movie_preview_component.dart';
import 'package:mittarv/common/ratings_component.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/features/auth/controller/auth_controller.dart';
import 'package:mittarv/features/auth/view/signuppage.dart';
import 'package:mittarv/features/movies/controllers/movie_controller.dart';
import 'package:mittarv/features/search/searchpage.dart';
import 'package:mittarv/features/user/controller/user_controller.dart';
import 'package:mittarv/model/movies_model.dart';
import 'package:mittarv/theme/pallete.dart';
import 'package:palette_generator/palette_generator.dart';

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
  final Color _iconColor = Colors.white;

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
        appBar: AppBar(
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
          backgroundColor: (_scrollPosition < 100)
              ? Pallete.deepBlueColor.withOpacity(0.0)
              : Pallete.deepBlueColor,
          actions: [
            IconButton(
              iconSize: 30,
              style: IconButton.styleFrom(
                backgroundColor: _iconColor,
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
                              ref
                                  .read(authControllerProvider.notifier)
                                  .logout(
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
                  backgroundColor: (user!=null)?Pallete.deepPurpleColor: Pallete.lightGreyColor,
                  child: (user != null)
                      ? Container(
                        decoration: BoxDecoration(
                          color: Pallete.deepPurpleColor,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              user.profilePic!,
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
        ),
        body: Stack(
          children: [
            (trendingMovies.isEmpty)
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: size.height * 0.3,
                                width: size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      "$backdropTmdbImageUrl/${trendingMovies[bannerIndex].backdropPath}",
                                    ),
                                    fit: BoxFit.fitHeight,
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
                                              .voteAverage??1)/2,),
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
                      ),
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
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.56,
                                    crossAxisSpacing: 15,
                                  ),
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
}

