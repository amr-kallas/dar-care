import 'package:dar_care/core/utils/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dar_care/core/theme/app_colors.dart';

import '../../../../../generated/locale_keys.g.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'provider_card.dart';
import 'section_header.dart';
import 'service_item.dart';

class ClientHomeBody extends StatelessWidget {
  const ClientHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeStatus.failure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }

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
                        border: Border.all(
                          color: isDark
                              ? Colors.transparent
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: const Stack(
                        children: [
                          Icon(SolarLinearIcons.bell),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: AppColors.errorRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              LocaleKeys.good_morning.tr(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              SolarBoldIcons.sun,
                              size: 14,
                              color: AppColors.warningOrange,
                            ),
                          ],
                        ),
                        Text(
                          LocaleKeys.welcome_back.tr(
                            namedArgs: {'name': 'Ahmed'},
                          ),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3',
                      ),
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
                        child: const Icon(
                          SolarLinearIcons.tuning,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AbsorbPointer(
                          // Prevent TextField focus
                          child: TextField(
                            textAlign:
                                TextAlign.right, // Arabic RTL alignment usually
                            decoration: InputDecoration(
                              hintText: LocaleKeys.search_hint.tr(),
                              hintStyle: const TextStyle(color: Colors.grey),
                              suffixIcon: const Icon(SolarLinearIcons.magnifer),
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.surfaceDark
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: isDark
                                    ? BorderSide.none
                                    : BorderSide(color: Colors.grey.shade200),
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

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return ServiceItem(
                      icon: category
                          .icon, // Assuming CategoryModel has an icon getter
                      label: category.name,
                      onTap: () {
                        // Navigate to category details or filter
                      },
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Providers Section
                SectionHeader(
                  title: LocaleKeys.section_providers_near.tr(),
                  actionText: LocaleKeys.see_all.tr(),
                  onTap: () {},
                ),
                const SizedBox(height: 16),

                if (state.topProviders.isEmpty)
                  const Center(child: Text('No providers found')),

                if (state.topProviders.isNotEmpty)
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: state.topProviders.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final provider = state.topProviders[index];
                        return ProviderCard(
                          name: provider.fullName,
                          profession: provider.profession,
                          rating: provider.rating,
                          distance: LocaleKeys.distance_from_you.tr(
                            namedArgs: {
                              'distance': '2.5',
                            }, // Mock distance for now
                          ),
                          imageUrl: provider.imageUrl ?? '',
                          onTap: () {
                            // Navigate to provider details
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 80), // Bottom spacer
              ],
            ),
          ),
        );
      },
    );
  }
}
