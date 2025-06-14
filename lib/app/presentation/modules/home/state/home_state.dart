import 'package:flutter/services.dart';
import 'package:memoraisa/app/core/constants/global.dart';
import 'package:memoraisa/app/core/generated/translations.g.dart';
import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    @Default(false) bool fetching,
    @Default(false) bool fileFetching,
    @Default(QuestionTypeEnum.single) QuestionTypeEnum questionType,
    @Default(Global.defaultNumberOfQuestions) int numberOfQuestions,
    @Default(null) Uint8List? file,
    @Default(null) String? fileName,
    @Default(AppLocale.en) AppLocale responseLocale,
  }) = _HomeState;
}
