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
import 'package:dar_care/core/widgets/custom_app_bar.dart';
import 'package:dar_care/generated/locale_keys.g.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.department});

  final CategoryModel department;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final departmentDescription = department.localizedDescription(languageCode);

    return BlocProvider(
      create: (context) =>
          getIt<SubCategoriesCubit>()..fetchSubCategories(department.id),
      child: Scaffold(
        appBar: CustomAppBar(
          titleWidget: Text(department.localizedName(languageCode)),
        ),
        body: BlocBuilder<SubCategoriesCubit, SubCategoriesState>(
          builder: (context, state) {
            if (state.status == SubCategoriesStatus.loading ||
                state.status == SubCategoriesStatus.initial) {
              return const AppLoadingIndicator();
            }

            if (state.status == SubCategoriesStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? LocaleKeys.home_error_generic.tr(),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (departmentDescription != null &&
                      departmentDescription.trim().isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.2),
                        ),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Text(
                        departmentDescription,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    LocaleKeys.section_services.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: state.subCategories.isEmpty
                        ? Center(
                            child: Text(LocaleKeys.subcategories_empty.tr()),
                          )
                        : GridView.builder(
                            itemCount: state.subCategories.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.8,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 12,
                                ),
                            itemBuilder: (context, index) {
                              final subCategory = state.subCategories[index];
                              return ServiceItem(
                                icon: SolarLinearIcons.box,
                                label: subCategory.localizedName(languageCode),
                                onTap: () {
                                  // Navigate to specific sub-category or provider list.
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
