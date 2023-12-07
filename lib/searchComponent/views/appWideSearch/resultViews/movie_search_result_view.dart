import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_flutter/base/helpers/string_parser.dart';
import 'package:campus_flutter/base/helpers/url_launcher.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:campus_flutter/base/enums/search_category.dart';
import 'package:campus_flutter/searchComponent/viewmodels/searchableViewModels/movie_search_viewmodel.dart';
import 'package:campus_flutter/searchComponent/views/appWideSearch/search_result_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieSearchResultView extends ConsumerWidget {
  const MovieSearchResultView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchResultCardView<MovieSearchViewModel, MovieSearch>(
      searchCategory: SearchCategory.movie,
      viewModel: movieSearchViewModel,
      body: (movieSearch) => ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: movieSearch.movie.coverUrl,
            fadeOutDuration: Duration.zero,
            fadeInDuration: Duration.zero,
            placeholder: (context, string) => Image.asset(
              "assets/images/placeholders/movie_placeholder.png",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/placeholders/movie_placeholder.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        title: Text(movieSearch.movie.title),
        subtitle: Text(
          StringParser.dateFormatter(
            movieSearch.movie.date.toDateTime(),
            context,
          ),
        ),
        onTap: () => UrlLauncher.urlString(
          movieSearch.movie.additionalInformationUrl,
          ref,
        ),
      ),
    );
  }
}
