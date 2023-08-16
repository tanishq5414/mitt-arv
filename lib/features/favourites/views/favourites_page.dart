import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mittarv/common/movie_preview_component.dart';
import 'package:mittarv/features/favourites/controller/favourites_controller.dart';
import 'package:mittarv/model/movies_model.dart';

class FavouritePageView extends ConsumerStatefulWidget {
  const FavouritePageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavouritePageViewState();
}

class _FavouritePageViewState extends ConsumerState<FavouritePageView> {
  @override
  void initState() {
    super.initState();
    ref
        .read(favouritesControllerProvider.notifier)
        .getFavourites(context: context);
  }

  @override
  Widget build(BuildContext context) {
    List<MoviesModel>? favourites = ref.watch(favouritesMovieProvider) ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(left: 20),
          child: const Text('Favourites'),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.567,
                ),
                itemCount: favourites.length,
                itemBuilder: (context, index) {
                  return MoviePreviewComponent(
                    size: MediaQuery.of(context).size,
                    movie: favourites[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
