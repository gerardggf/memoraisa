import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/quizz_state.dart';

final quizzControllerProvider =
    StateNotifierProvider.autoDispose<QuizzController, QuizzState>(
      (ref) => QuizzController(QuizzState()),
    );

class QuizzController extends StateNotifier<QuizzState> {
  QuizzController(super.state);

  void updateFetching(bool value) {
    state = state.copyWith(fetching: value);
  }

  void updateShowAnswers(bool value) {
    state = state.copyWith(showAnswers: value);
  }

  void updateSelectedAnswers(Map<int, String?> value) {
    state = state.copyWith(selectedAnswers: value);
  }
}
