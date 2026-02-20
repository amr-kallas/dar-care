import 'package:dar_care/core/utils/app_router.dart';
import 'package:dar_care/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/onboarding_model.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_footer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  final List<OnboardingModel> _onboardingItems = [
    OnboardingModel(
      lottieAsset: Assets.json.homeService,
      title: LocaleKeys.onboarding_title_1.tr(),
      subtitle: LocaleKeys.onboarding_subtitle_1.tr(),
    ),
    OnboardingModel(
      lottieAsset: Assets.json.homeBoilerCare,
      title: LocaleKeys.onboarding_title_2.tr(),
      subtitle: LocaleKeys.onboarding_subtitle_2.tr(),
    ),
    OnboardingModel(
      lottieAsset: Assets.json.a24Emergency,
      title: LocaleKeys.onboarding_title_3.tr(),
      subtitle: LocaleKeys.onboarding_subtitle_3.tr(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_pageController.page!.toInt() == _onboardingItems.length - 1) {
      context.go(AppRouter.authGatePath);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkipPressed() {
    context.go(AppRouter.authGatePath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final pageIndex = (state is OnboardingInitial)
                ? state.pageIndex
                : 0;
            final isLastPage = pageIndex == _onboardingItems.length - 1;

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingItems.length,
                    onPageChanged: (index) {
                      context.read<OnboardingCubit>().onPageChanged(index);
                    },
                    itemBuilder: (context, index) {
                      return OnboardingContent(item: _onboardingItems[index]);
                    },
                  ),
                ),
                OnboardingFooter(
                  pageController: _pageController,
                  onNextPressed: _onNextPressed,
                  onSkipPressed: _onSkipPressed,
                  itemCount: _onboardingItems.length,
                  isLastPage: isLastPage,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
