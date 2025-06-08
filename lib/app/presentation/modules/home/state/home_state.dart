import 'dart:io';

import 'package:memoraisa/app/core/generated/translations.g.dart';
import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(false) bool fetching,
    @Default(QuestionTypeEnum.single) QuestionTypeEnum questionType,
    @Default(null) File? file,
    @Default(AppLocale.en) AppLocale responseLocale,
  }) = _HomeState;
}
