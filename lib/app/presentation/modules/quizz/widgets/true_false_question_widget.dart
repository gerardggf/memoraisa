import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoraisa/app/core/utils/extensions/num_to_sizedbox.dart';
import 'package:memoraisa/app/core/utils/extensions/theme_mode_extension.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:memoraisa/app/presentation/modules/quizz/quizz_controller.dart';

import '../../../../core/constants/colors.dart';

class TrueFalseQuestionWidget extends ConsumerStatefulWidget {
  const TrueFalseQuestionWidget({
    super.key,
    required this.question,
    required this.onSelectAnswer,
    required this.selectedAnswer,
    required this.index,
  });

  final TrueOrFalseQuestionModel question;
  final void Function(bool?) onSelectAnswer;
  final bool? selectedAnswer;
  final int index;

  @override
  ConsumerState<TrueFalseQuestionWidget> createState() =>
      _QuestionWidgetState();
}

class _QuestionWidgetState extends ConsumerState<TrueFalseQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    final darkMode = context.isDarkMode;
    final state = ref.watch(quizzControllerProvider);
    return AbsorbPointer(
      absorbing: state.showAnswers,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.selectedAnswer != widget.question.answer
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
                  InkWell(
                    onTap: () {
                      widget.onSelectAnswer(true);
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
                            value: true,
                            onChanged: state.showAnswers
                                ? null
                                : (_) {
                                    widget.onSelectAnswer(true);
                                  },
                            side: BorderSide(
                              color: darkMode ? Colors.black : Colors.white,
                            ),
                            activeColor: darkMode ? Colors.black : Colors.white,
                            checkColor: darkMode
                                ? Colors.white
                                : AppColors.light,
                          ),
                          Expanded(
                            child: Text(
                              'True',
                              style: TextStyle(
                                color: darkMode ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.onSelectAnswer(false);
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
                            value: false,
                            onChanged: state.showAnswers
                                ? null
                                : (_) {
                                    widget.onSelectAnswer(false);
                                  },
                            side: BorderSide(
                              color: darkMode ? Colors.black : Colors.white,
                            ),
                            activeColor: darkMode ? Colors.black : Colors.white,
                            checkColor: darkMode
                                ? Colors.white
                                : AppColors.light,
                          ),
                          Expanded(
                            child: Text(
                              'False',
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
                  widget.question.answer ? 'True' : 'False',
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
