import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mittarv/common/movie_preview_component.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/features/movies/controllers/moviecontroller.dart';
import 'package:mittarv/features/search/searchpage.dart';
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
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _scrollListener();
    });
    _loadMore();
  }

  void _scrollListener() {
    _scrollPosition = _scrollController.position.pixels;
    double opacity = _scrollPosition / 600;
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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 80,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Pallete.whiteColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Pallete.backgroundColor,
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
            ),
          ],
        ),
        body: Stack(
          children: [
            LazyLoadScrollView(
              isLoading: isLoading, // Set the loading indicator state here
              onEndOfPage: () => _loadMore(),
              child: (trendingMovies.isEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: size.height * 0.7,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        "$tmdbImageURL/${trendingMovies[12].posterPath}",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.7,
                                  width: size.width,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent,
                                        Pallete.backgroundColor,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.7,
                                  width: size.width,
                                  color: Pallete.backgroundColor
                                      .withOpacity(backgroundOpacity),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Rating: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              '${trendingMovies[12].voteAverage} ⭐',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Color.fromARGB(
                                                        255, 215, 202, 202),
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${trendingMovies[12].genreIds![0]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Color.fromARGB(
                                                    255, 215, 202, 202),
                                              ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Pallete.whiteColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          child: Text('Details',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                        ),
                                      ),
                                    ),
                                  ],
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
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.8,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Top Rated',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: trendingMovies.length,
                                  itemBuilder: (context, position) {
                                    return MoviePreviewComponent(
                                        size: size,
                                        trendingMovies: trendingMovies,
                                        index: position);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
