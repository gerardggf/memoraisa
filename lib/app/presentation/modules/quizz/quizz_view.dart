import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoraisa/app/core/utils/extensions/num_to_sizedbox.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:memoraisa/app/presentation/modules/quizz/quizz_controller.dart';
import 'package:memoraisa/app/presentation/modules/quizz/widgets/question_widget.dart';

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
    final notifier = ref.read(quizzControllerProvider.notifier);
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
                return QuestionWidget(
                  index: index + 1,
                  question: question,
                  onSelectAnswer: (answer) {
                    if (answer == state.selectedAnswers[index]) {
                      notifier.updateSelectedAnswers(
                        Map.from(state.selectedAnswers)..[index] = null,
                      );
                      return;
                    }
                    notifier.updateSelectedAnswers(
                      Map.from(state.selectedAnswers)..[index] = answer,
                    );
                  },
                  selectedAnswer: state.selectedAnswers[index],
                );
              },
            ),
          ),
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                10.w,
                if (state.selectedAnswers.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      notifier.updateSelectedAnswers({});
                    },
                    icon: Icon(Icons.deselect),
                  ),
                Spacer(),
                Text(
                  '${state.showAnswers ? widget.quizz.questions.map((e) => e.correctAnswer).toSet().intersection(state.selectedAnswers.values.toSet()).toList().length : '-'} / ${widget.quizz.questions.length}',
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
