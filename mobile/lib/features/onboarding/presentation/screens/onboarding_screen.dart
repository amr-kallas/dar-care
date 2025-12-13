import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../generated/local_keys.g.dart';
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
      lottieAsset: 'assets/json/Home Service.json',
      title: LocaleKeys.onboarding_title_1.tr(),
      subtitle: LocaleKeys.onboarding_subtitle_1.tr(),
    ),
    OnboardingModel(
      lottieAsset: 'assets/json/Home & Boiler Care.json',
      title: LocaleKeys.onboarding_title_2.tr(),
      subtitle:  LocaleKeys.onboarding_subtitle_2.tr(),
    ),
    OnboardingModel(
      lottieAsset: 'assets/json/24Emergency.json',
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
      // Navigator.of(context).pushReplacementNamed('/login');
      log("Go to Login Screen");
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
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
                    itemCount: _onboardingItems.length,
                    isLastPage: isLastPage,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
