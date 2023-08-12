import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mittarv/config.dart';
import 'package:mittarv/features/movies/controllers/moviecontroller.dart';
import 'package:mittarv/features/search/searchpage.dart';
import 'package:mittarv/model/movies_model.dart';

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<HomePageView> {
  int page = 0; // Move this line here
  late List<MoviesModel> trendingMovies = []; // Initialize as empty list
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    setState(() {
      isLoading = true;
    });
    page++;
    await Future.delayed(const Duration(seconds: 2));
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
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   actions: [
        //     IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           SearchPageView.route(),
        //         );
        //       },
        //       icon: const Icon(Icons.search),
        //     ),
        //   ],
        // ),
        body: LazyLoadScrollView(
          isLoading: isLoading, // Set the loading indicator state here
          onEndOfPage: () => _loadMore(),
          child: Stack(
            children: [
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.6,
              //     width: MediaQuery.of(context).size.width * 0.8,
              //     decoration:  BoxDecoration(
              //       image: DecorationImage(
              //         image: NetworkImage(
              //           "$tmdbImageURL/${trendingMovies[0].posterPath }"
              //         ),
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   ),
              // ),
              Scrollbar(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: trendingMovies.length,
                  itemBuilder: (context, position) {
                    return Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "$tmdbImageURL/${trendingMovies[position].posterPath}",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Text(
                                        trendingMovies[position].title!,
                                        maxLines: 3,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // Text(
                                    //   trendingMovies[position].overview!,
                                    //   maxLines: 5,
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
