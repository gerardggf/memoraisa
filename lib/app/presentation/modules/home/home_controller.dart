import 'dart:typed_data';

import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:memoraisa/app/core/utils/typedefs.dart';
import 'package:memoraisa/app/data/services/api_service.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:memoraisa/app/domain/repositories/prefs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/home_state.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(
    HomeState(),
    ref.read(apiServiceProvider),
    ref.read(prefsRepoProvider),
  ),
);

class HomeController extends StateNotifier<HomeState> {
  HomeController(super.state, this.apiService, this.prefsRepository);

  final ApiService apiService;
  final PrefsRepository prefsRepository;

  void updateFetching(bool value) {
    state = state.copyWith(fetching: value);
  }

  void updateFileFetching(bool value) {
    state = state.copyWith(fileFetching: value);
  }

  void updateFile(Uint8List fileBytes, String fileName) {
    state = state.copyWith(file: fileBytes, fileName: fileName);
  }

  void updateQuestionType(QuestionTypeEnum value) {
    state = state.copyWith(questionType: value);
  }

  AsyncResult<QuizzModel> submit() async {
    updateFetching(true);
    final result = await apiService.sendPrompt(
      fileBytes: state.file,
      fileName: state.fileName,
      questionType: state.questionType,
    );
    updateFetching(false);
    return result;
  }
}
