import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoraisa/app/core/utils/extensions/num_to_sizedbox.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:memoraisa/app/presentation/modules/quizz/quizz_controller.dart';
import 'package:memoraisa/app/presentation/shared/controllers/theme_controller.dart';

import '../../../../core/constants/colors.dart';

class QuestionWidget extends ConsumerStatefulWidget {
  const QuestionWidget({
    super.key,
    required this.question,
    required this.onSelectAnswer,
    required this.selectedAnswer,
    required this.index,
  });

  final QuestionModel question;
  final void Function(String?) onSelectAnswer;
  final String? selectedAnswer;
  final int index;

  @override
  ConsumerState<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends ConsumerState<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeControllerProvider).darkMode;
    final state = ref.watch(quizzControllerProvider);
    return AbsorbPointer(
      absorbing: state.showAnswers,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.selectedAnswer != widget.question.correctAnswer
              ? Colors.red
              : Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: darkMode ? Colors.white : AppColors.light,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.index}. ${widget.question.term}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: darkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  10.h,
                  for (var answer in widget.question.answers)
                    InkWell(
                      onTap: () {
                        widget.onSelectAnswer(answer);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: darkMode ? AppColors.darkBg : Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: answer == widget.selectedAnswer,
                              onChanged: state.showAnswers
                                  ? null
                                  : (_) {
                                      widget.onSelectAnswer(answer);
                                    },
                              side: BorderSide(
                                color: darkMode ? Colors.black : Colors.white,
                              ),
                              activeColor: darkMode
                                  ? Colors.black
                                  : Colors.white,
                              checkColor: darkMode
                                  ? Colors.white
                                  : AppColors.light,
                            ),
                            Expanded(
                              child: Text(
                                '${mapIndex(widget.question.answers.indexOf(answer))} $answer',
                                style: TextStyle(
                                  color: darkMode ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (state.showAnswers)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  '${mapIndex(widget.question.answers.indexOf(widget.question.correctAnswer))} ${widget.question.correctAnswer}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String mapIndex(int index) {
    switch (index) {
      case 0:
        return 'a)';
      case 1:
        return 'b)';
      case 2:
        return 'c)';
      case 3:
        return 'd)';
      case 4:
        return 'e)';
      default:
        return '';
    }
  }
}
