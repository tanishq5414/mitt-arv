import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/common/movie_preview_component.dart';
import 'package:mittarv/features/movies/controllers/moviecontroller.dart';
import 'package:mittarv/model/movies_model.dart';
import 'package:mittarv/theme/pallete.dart';

class SearchPageView extends ConsumerStatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SearchPageView());
  }

  const SearchPageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends ConsumerState<SearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  List<MoviesModel> _searchResults = [];
  bool _isLoading = false;

  Future<void> _onSearchTextChanged(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await ref.read(movieControllerProvider.notifier).searchMoviesByQuery(
          context: context,
          query: searchText,
        );
    final newMovies = ref.read(searchMoviesProvider) ?? [];
    setState(() {
      _searchResults = newMovies;
      _searchResults.removeWhere((element) => element.backdropPath == null);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Pallete.whiteColor,
                      ),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Pallete.whiteColor,
                        ),
                    hintText: 'Search For Movies',
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Pallete.greyColor,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ),
                  onChanged: _onSearchTextChanged,
                ),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      flex: 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return MoviePreviewComponent(
                            size: size,
                            movie: _searchResults[index],
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
