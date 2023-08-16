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
              SizedBox(
                height: 60,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Pallete.whiteColor,
                        ),
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintStyle:
                          Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Pallete.lightGreyColor.withOpacity(0.5),
                              ),
                      fillColor: Pallete.otherBlueColor,
                      filled: true,
                      hintText: 'FIND A FILM',
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff909Ea9),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff909Ea9),
                        ),
                      ),
                    ),
                    onChanged: _onSearchTextChanged,
                  ),
                ),
              ),
              Row(
                children: [
                  filterValueDropDownComponent(
                      size, context, ["Popularity", "Highest", "Lowest"]),
                  filterValueDropDownComponent(
                      size, context, ["Rating", "Highest", "Lowest"]),
                  filterValueDropDownComponent(
                      size, context, ["Year", "Highest", "Lowest"]),
                ],
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      flex: 1,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.574,
                        ),
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

  filterValueDropDownComponent(
      Size size, BuildContext context, List<String> items) {
    return Flexible(
      flex: 1,
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            buttonColor: Colors.transparent,
            alignedDropdown: true,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(10),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderSide: BorderSide(
                    color: Color(0xff909Ea9),
                  ),
                ),
              ),
              focusColor: Colors.white,
              focusNode: FocusNode(),
              padding: EdgeInsets.zero,
              value: items[0],
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 11,
                    color: Pallete.whiteColor,
                  ),
              dropdownColor: const Color(0xff364452),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ),
        ),
      ),
    );
  }
}
