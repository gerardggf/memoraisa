import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoraisa/app/core/utils/extensions/num_to_sizedbox.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: darkMode ? Colors.white : AppColors.light,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.all(10),

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
                      onChanged: (_) {},
                      activeColor: darkMode ? Colors.black : Colors.white,
                      checkColor: darkMode ? Colors.white : AppColors.light,
                    ),
                    Expanded(
                      child: Text(
                        answer,
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
    );
  }
}
