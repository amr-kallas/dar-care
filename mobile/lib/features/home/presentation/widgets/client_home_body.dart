import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'provider_card.dart';
import 'section_header.dart';
import 'service_item.dart';

class ClientHomeBody extends StatelessWidget {
  const ClientHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                // Notification Button
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.transparent : Colors.grey.shade200),
                  ),
                  child: const Stack(
                      children: [
                         Icon(Icons.notifications_none_rounded),
                         Positioned(
                           right: 0,
                           top: 0,
                           child: CircleAvatar(
                             radius: 4,
                             backgroundColor: AppColors.errorRed,
                           ),
                         )
                      ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                         Text(LocaleKeys.good_morning.tr(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                         const SizedBox(width: 4),
                         const Icon(Icons.wb_sunny_rounded, size: 14, color: AppColors.warningOrange),
                      ],
                    ),
                    Text(
                      LocaleKeys.welcome_back.tr(namedArgs: {'name': 'Ahmed'}),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'), 
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Search Bar
            GestureDetector(
              onTap: () => context.push(AppRouter.searchResultsPath),
              child: Row(
                children: [
                   Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.brightGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                   ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: AbsorbPointer( // Prevent TextField focus
                       child: TextField(
                         textAlign: TextAlign.right, // Arabic RTL alignment usually
                         decoration: InputDecoration(
                           hintText: LocaleKeys.search_hint.tr(),
                           hintStyle: const TextStyle(color: Colors.grey),
                           suffixIcon: const Icon(Icons.search),
                           filled: true,
                           fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(16),
                             borderSide: BorderSide.none,
                           ),
                           enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(16),
                             borderSide: isDark ? BorderSide.none : BorderSide(color: Colors.grey.shade200),
                           ),
                         ),
                       ),
                     ),
                   ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Services Section
            SectionHeader(
              title: LocaleKeys.section_services.tr(),
              actionText: LocaleKeys.see_all.tr(),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              children: [
                ServiceItem(
                  icon: Icons.plumbing,
                  label: LocaleKeys.service_plumbing.tr(),
                  onTap: () {},
                ),
                ServiceItem(
                  icon: Icons.ac_unit,
                  label: LocaleKeys.service_ac.tr(),
                  onTap: () {},
                ),
                ServiceItem(
                  icon: Icons.electrical_services,
                  label: LocaleKeys.service_electric.tr(),
                  onTap: () {},
                ),
                ServiceItem(
                  icon: Icons.cleaning_services,
                  label: LocaleKeys.service_cleaning.tr(),
                  onTap: () {},
                ),
                ServiceItem(
                  icon: Icons.carpenter,
                  label: LocaleKeys.service_carpentry.tr(),
                  onTap: () {},
                ),
                ServiceItem(
                  icon: Icons.pest_control,
                  label: LocaleKeys.service_pest_control.tr(),
                  onTap: () {},
                ),
                ServiceItem(
                  icon: Icons.format_paint,
                  label: LocaleKeys.service_painting.tr(),
                  onTap: () {},
                ),
                ServiceItem(
                  icon: Icons.grid_view,
                  label: LocaleKeys.service_more.tr(),
                  isMore: true,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Providers Section
            SectionHeader(
              title: LocaleKeys.section_providers_near.tr(),
              actionText: LocaleKeys.see_all.tr(),
              onTap: () {},
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 220, 
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  ProviderCard(
                    name: 'Mohammed Ali',
                    profession: LocaleKeys.profession_plumber.tr(),
                    rating: 4.8,
                    distance: LocaleKeys.distance_from_you.tr(namedArgs: {'distance': '1.2'}),
                    imageUrl: '',
                    onTap: () {},
                  ),
                   ProviderCard(
                    name: 'Sami Ahmed',
                    profession: LocaleKeys.profession_electrician.tr(),
                    rating: 4.5,
                    distance: LocaleKeys.distance_from_you.tr(namedArgs: {'distance': '2.5'}),
                    imageUrl: '',
                    onTap: () {},
                  ),
                ],
              ),
            ),
             const SizedBox(height: 80), // Bottom spacer
          ],
        ),
      ),
    );
  }
}

