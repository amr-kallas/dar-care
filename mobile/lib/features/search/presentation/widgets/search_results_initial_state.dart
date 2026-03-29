import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchResultsInitialState extends StatelessWidget {
  const SearchResultsInitialState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(LocaleKeys.search_hint.tr(), textAlign: TextAlign.center),
    );
  }
}
