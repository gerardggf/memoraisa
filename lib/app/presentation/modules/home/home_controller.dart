import 'dart:io';

import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:memoraisa/app/core/utils/typedefs.dart';
import 'package:memoraisa/app/data/services/api_service.dart';
import 'package:memoraisa/app/domain/models/message_model.dart';
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

  void updateFile(File value) {
    state = state.copyWith(file: value);
  }

  void updateQuestionType(QuestionTypeEnum value) {
    state = state.copyWith(questionType: value);
  }

  AsyncResult<MessageModel> submit() async {
    updateFetching(true);
    final result = apiService.sendPrompt(
      file: state.file,
      questionType: state.questionType,
    );
    updateFetching(false);
    return result;
  }
}
