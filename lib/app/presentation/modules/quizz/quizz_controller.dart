import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/quizz_state.dart';

final quizzControllerProvider =
    StateNotifierProvider<QuizzController, QuizzState>(
      (ref) => QuizzController(QuizzState()),
    );

class QuizzController extends StateNotifier<QuizzState> {
  QuizzController(super.state);

  void updateFetching(bool value) {
    state = state.copyWith(fetching: value);
  }

  void updateSelectedAnswers(Map<int, String?> value) {
    state = state.copyWith(selectedAnswers: value);
  }
}
