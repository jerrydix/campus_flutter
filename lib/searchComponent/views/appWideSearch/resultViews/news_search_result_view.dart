import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_flutter/base/enums/search_category.dart';
import 'package:campus_flutter/base/helpers/string_parser.dart';
import 'package:campus_flutter/base/helpers/url_launcher.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:campus_flutter/searchComponent/viewmodels/searchableViewModels/news_search_viewmodel.dart';
import 'package:campus_flutter/searchComponent/views/appWideSearch/search_result_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsSearchResultView extends ConsumerWidget {
  const NewsSearchResultView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchResultCardView<NewsSearchViewModel, NewsSearch>(
      searchCategory: SearchCategory.news,
      viewModel: newsSearchViewModel,
      body: (newsSearch) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
              height: 60,
              imageUrl: newsSearch.news.imageUrl,
              placeholder: (context, string) => Image.asset(
                "assets/images/placeholders/news_placeholder.png",
                fit: BoxFit.fill,
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/placeholders/news_placeholder.png",
                fit: BoxFit.fill,
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
          title: Text(newsSearch.news.title),
          subtitle: Text(
            StringParser.dateFormatter(
              newsSearch.news.date.toDateTime(),
              context,
            ),
          ),
          onTap: () => UrlLauncher.urlString(newsSearch.news.link, ref),
        );
      },
    );
  }
}
