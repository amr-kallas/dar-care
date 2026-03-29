import 'package:dar_care/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:dar_care/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:dar_care/features/search/presentation/cubit/search_cubit.dart';
import 'package:dar_care/features/search/presentation/widgets/promo_banner.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_body.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_filters.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_header.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_search_controls.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_snackbar.dart';

class SearchResultsContent extends StatefulWidget {
  const SearchResultsContent({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<SearchResultsContent> createState() => _SearchResultsContentState();
}

class _SearchResultsContentState extends State<SearchResultsContent> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    context.read<SearchCubit>().search(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null) return;
        AppSnackbar.showError(context, message);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SearchResultsHeader(onBackTap: () => Navigator.of(context).pop()),
              SearchResultsSearchControls(
                controller: _searchController,
                onSubmitSearch: _submitSearch,
              ),
              const SizedBox(height: 24),
              const SearchResultsFilters(),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: PromoBanner(),
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
      ),
    );
  }
}
