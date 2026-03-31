import 'package:dar_care/features/home/data/models/category_model.dart';
import 'package:dar_care/features/home/data/models/provider_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<CategoryModel> categories,
    @Default([]) List<ProviderModel> topProviders,
    @Default(HomeStatus.initial) HomeStatus status,
    String? errorMessage,
  }) = _HomeState;
}

enum HomeStatus { initial, loading, success, failure }
