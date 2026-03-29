import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchResultsEmptyState extends StatelessWidget {
  const SearchResultsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        LocaleKeys.search_results_found.tr(namedArgs: {'count': '0'}),
        textAlign: TextAlign.center,
      ),
    );
  }
}
