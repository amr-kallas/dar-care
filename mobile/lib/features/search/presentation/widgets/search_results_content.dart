import 'dart:async';

import 'package:dar_care/features/search/presentation/cubit/search_cubit.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_body.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_header.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_search_controls.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsContent extends StatefulWidget {
  const SearchResultsContent({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<SearchResultsContent> createState() => _SearchResultsContentState();
}

class _SearchResultsContentState extends State<SearchResultsContent> {
  late final TextEditingController _searchController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    context.read<SearchCubit>().search(_searchController.text);
  }

  void _onQueryChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), _submitSearch);
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchResultsHeader(onBackTap: () => Navigator.of(context).pop()),
            SearchResultsSearchControls(
              controller: _searchController,
              onSubmitSearch: _submitSearch,
              onQueryChanged: _onQueryChanged,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SearchResultsBody(
                onRetry: _submitSearch,
                languageCode: languageCode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
