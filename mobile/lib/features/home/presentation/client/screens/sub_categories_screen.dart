import 'package:dar_care/core/widgets/app_loading_indicator.dart';
import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/presentation/client/cubit/sub_categories/sub_categories_cubit.dart';
import 'package:dar_care/features/home/presentation/client/cubit/sub_categories/sub_categories_state.dart';
import 'package:dar_care/features/home/presentation/client/widgets/service_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:dar_care/core/di/injection.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.department});

  final CategoryModel department;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return BlocProvider(
      create: (context) =>
          getIt<SubCategoriesCubit>()..fetchSubCategories(department.id),
      child: Scaffold(
        appBar: AppBar(title: Text(department.localizedName(languageCode))),
        body: BlocBuilder<SubCategoriesCubit, SubCategoriesState>(
          builder: (context, state) {
            if (state.status == SubCategoriesStatus.loading ||
                state.status == SubCategoriesStatus.initial) {
              return const AppLoadingIndicator();
            }

            if (state.status == SubCategoriesStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Error loading subcategories',
                ),
              );
            }

            if (state.subCategories.isEmpty) {
              return const Center(child: Text('No subcategories found.'));
            }

            return Padding(
              padding: const EdgeInsets.all(24),
              child: GridView.builder(
                itemCount: state.subCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final subCategory = state.subCategories[index];
                  // Using default icon or we could add imageUrl mapping if needed later.
                  return ServiceItem(
                    icon: SolarLinearIcons.box, // Default icon
                    label: subCategory.localizedName(languageCode),
                    onTap: () {
                      // Navigate to specific sub-category or provider list
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
