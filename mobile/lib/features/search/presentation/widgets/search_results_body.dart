import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/features/search/presentation/cubit/search_cubit.dart';
import 'package:dar_care/features/search/presentation/cubit/search_state.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_empty_state.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_failure_state.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_initial_state.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_list.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsBody extends StatelessWidget {
  const SearchResultsBody({
    super.key,
    required this.onRetry,
    required this.languageCode,
  });

  final VoidCallback onRetry;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.status == SearchStatus.loading) {
          return const AppLoadingIndicator();
        }

        if (state.status == SearchStatus.failure) {
          return SearchResultsFailureState(
            message: LocaleKeys.search_results_error_generic.tr(),
            onRetry: onRetry,
          );
        }

        if (state.status == SearchStatus.initial) {
          return const SearchResultsInitialState();
        }

        if (state.results.isEmpty) {
          return const SearchResultsEmptyState();
        }

        return SearchResultsList(
          results: state.results,
          languageCode: languageCode,
        );
      },
    );
  }
}
