import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/presentation/client/widgets/section_header.dart';
import 'package:dar_care/features/home/presentation/client/widgets/service_item.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientHomeServicesSection extends StatelessWidget {
  const ClientHomeServicesSection({
    super.key,
    required this.categories,
    required this.languageCode,
  });

  final List<CategoryModel> categories;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: LocaleKeys.section_services.tr(),
          actionText: LocaleKeys.see_all.tr(),
          onTap: () => context.push(AppRouter.allDepartmentsPath, extra: categories),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (context) {
            const previewSlots = 8;
            final hasMore = categories.length > previewSlots;
            final previewCount = hasMore ? previewSlots : categories.length;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
              ),
              itemCount: previewCount,
              itemBuilder: (context, index) {
                final isMoreTile = hasMore && index == previewSlots - 1;
                if (isMoreTile) {
                  return ServiceItem(
                    icon: Icons.more_horiz,
                    label: LocaleKeys.service_more.tr(),
                    isMore: true,
                    onTap: () => context.push(
                      AppRouter.allDepartmentsPath,
                      extra: categories,
                    ),
                  );
                }

                final category = categories[index];
                return ServiceItem(
                  icon: category.icon,
                  label: category.localizedName(languageCode),
                  imageUrl: category.imageUrl,
                  onTap: () {
                    context.push(AppRouter.subCategoriesPath, extra: category);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

