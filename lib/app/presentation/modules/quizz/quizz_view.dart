import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(title: Text(widget.quizz.quizzName)),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.quizz.questions.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.quizz.questions.length) {
            return Padding(
              padding: const EdgeInsets.all(10).copyWith(bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  notifier.updateShowAnswers(
                    !ref.read(quizzControllerProvider).showAnswers,
                  );
                },
                child: const Text('Show answers'),
              ),
            );
          }
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
    );
  }
}
