import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/features/movies/controllers/moviecontroller.dart';
import 'package:mittarv/model/movies_model.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              decoration: const InputDecoration(
                hintText: 'Search...',
              ),
            ),
          ),
          (_isLoading)?
          const Center(child: CircularProgressIndicator()):
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index].title!),
                  // You can customize the list item's appearance here
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
