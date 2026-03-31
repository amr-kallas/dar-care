import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dar_care/features/home/data/models/sub_category_model.dart';

part 'sub_categories_state.freezed.dart';

enum SubCategoriesStatus { initial, loading, success, failure }

@freezed
abstract class SubCategoriesState with _$SubCategoriesState {
  const factory SubCategoriesState({
    @Default([]) List<SubCategoryModel> subCategories,
    @Default(SubCategoriesStatus.initial) SubCategoriesStatus status,
    String? errorMessage,
  }) = _SubCategoriesState;
}

