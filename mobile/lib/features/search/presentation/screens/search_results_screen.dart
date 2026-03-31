import 'package:dar_care/core/di/injection.dart';
import 'package:dar_care/features/search/presentation/cubit/search_cubit.dart';
import 'package:dar_care/features/search/presentation/widgets/search_results_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  Widget build(BuildContext context) {
    final query = initialQuery?.trim() ?? '';

    return BlocProvider(
      create: (context) {
        final cubit = getIt<SearchCubit>();
        if (query.isNotEmpty) {
          cubit.search(query);
        }
        return cubit;
      },
      child: SearchResultsContent(initialQuery: query),
    );
  }
}
