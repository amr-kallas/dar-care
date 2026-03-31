import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/presentation/client/widgets/service_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/app_router.dart';
import '../../../../../generated/locale_keys.g.dart';

class AllDepartmentsScreen extends StatelessWidget {
  const AllDepartmentsScreen({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.section_services.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
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
        ),
      ),
    );
  }
}

