import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoraisa/app/core/utils/extensions/num_to_sizedbox.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:memoraisa/app/presentation/modules/quizz/quizz_controller.dart';
import 'package:memoraisa/app/presentation/modules/quizz/widgets/multiple_question_widget.dart';
import 'package:memoraisa/app/presentation/modules/quizz/widgets/single_question_widget.dart';
import 'package:memoraisa/app/presentation/modules/quizz/widgets/true_false_question_widget.dart';

class QuizzView extends ConsumerStatefulWidget {
  const QuizzView(this.quizz, {super.key});

  final QuizzModel quizz;

  static const String routeName = '/quizz';

  @override
  ConsumerState<QuizzView> createState() => _QuizzViewState();
}

class _QuizzViewState extends ConsumerState<QuizzView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizzControllerProvider);
    print(widget.quizz.toJson());
    final notifier = ref.read(quizzControllerProvider.notifier);
    final answeredQuestions = () {
      int correct = 0;
      for (int i = 0; i < widget.quizz.questions.length; i++) {
        final question = widget.quizz.questions[i];
        switch (widget.quizz.questionType) {
          case 'single':
            final userAnswer = state.singleSelectedAnswers[i];
            if (question is SingleQuestionModel &&
                userAnswer != null &&
                userAnswer == question.correctAnswer) {
              correct++;
            }
            break;
          case 'multiple':
            final userAnswers = state.multipleSelectedAnswers[i];
            if (question is MultipleQuestionModel &&
                userAnswers is List<String>) {
              final correctAnswers = question.correctAnswers.toSet();
              final selectedSet = userAnswers.toSet();
              if (correctAnswers.length == selectedSet.length &&
                  correctAnswers.difference(selectedSet).isEmpty) {
                correct++;
              }
            }
            break;
          case 'truefalse':
            final userAnswer = state.trueFalseSelectedAnswers[i];
            if (question is TrueOrFalseQuestionModel &&
                userAnswer != null &&
                userAnswer == question.answer) {
              correct++;
            }
            break;
        }
      }
      return correct;
    }();

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(widget.quizz.quizzName),
        ),
        actions: [10.w],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.quizz.questions.length,
              itemBuilder: (context, index) {
                final question = widget.quizz.questions[index];
                switch (widget.quizz.questionType) {
                  case 'single':
                    return SingleQuestionWidget(
                      index: index + 1,
                      question: question,
                      onSelectAnswer: (answer) {
                        if (answer == state.singleSelectedAnswers[index]) {
                          notifier.updateSingleSelectedAnswers(
                            Map.from(state.singleSelectedAnswers)
                              ..[index] = null,
                          );
                          return;
                        }
                        notifier.updateSingleSelectedAnswers(
                          Map.from(state.singleSelectedAnswers)
                            ..[index] = answer,
                        );
                      },
                      selectedAnswer: state.singleSelectedAnswers[index],
                    );
                  case 'multiple':
                    return MultipleQuestionWidget(
                      index: index + 1,
                      question: question,
                      onSelectAnswer: (answers) {
                        if (answers == null) return;

                        notifier.updateMultipleSelectedAnswers(
                          Map.from(state.multipleSelectedAnswers)
                            ..[index] = answers,
                        );
                      },
                      selectedAnswers: state.multipleSelectedAnswers[index],
                    );
                  case 'truefalse':
                    return TrueFalseQuestionWidget(
                      index: index + 1,
                      question: question,
                      onSelectAnswer: (answer) {
                        if (answer == null) return;
                        notifier.updateTruefalseSelectedAnswers(
                          Map.from(state.trueFalseSelectedAnswers)
                            ..[index] = answer,
                        );
                      },
                      selectedAnswer: state.trueFalseSelectedAnswers[index],
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                10.w,
                if (state.singleSelectedAnswers.isNotEmpty ||
                    state.multipleSelectedAnswers.isNotEmpty ||
                    state.trueFalseSelectedAnswers.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      notifier.clearAllAnswers();
                    },
                    icon: Icon(Icons.deselect),
                  ),
                Spacer(),
                Text(
                  '${state.showAnswers ? answeredQuestions : '-'} / ${widget.quizz.questions.length}',
                ),
                15.w,
                ElevatedButton(
                  onPressed: () {
                    notifier.updateShowAnswers(!state.showAnswers);
                  },
                  child: Text(
                    state.showAnswers ? 'Hide answers' : 'Show answers',
                  ),
                ),
                10.w,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
