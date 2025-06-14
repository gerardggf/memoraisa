import 'package:freezed_annotation/freezed_annotation.dart';

part 'quizz_state.freezed.dart';

@freezed
class QuizzState with _$QuizzState {
  factory QuizzState({
    @Default(false) bool fetching,
    @Default(false) bool showAnswers,
    @Default({}) Map<int, String?> singleSelectedAnswers,
    @Default({}) Map<int, List<String>?> multipleSelectedAnswers,
    @Default({}) Map<int, bool?> trueFalseSelectedAnswers,
  }) = _QuizzState;
}
