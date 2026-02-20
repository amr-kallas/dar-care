import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitial());

  void onPageChanged(int index) {
    emit(OnboardingInitial(pageIndex: index));
  }
}
