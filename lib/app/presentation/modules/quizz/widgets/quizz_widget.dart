import 'package:flutter/material.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';

import '../../../../core/constants/colors.dart';

class QuizzWidget extends StatefulWidget {
  const QuizzWidget({
    super.key,
    required this.question,
    required this.onSelectAnswer,
    required this.selectedAnswer,
  });

  final QuestionModel question;
  final void Function(String?) onSelectAnswer;
  final String? selectedAnswer;

  @override
  State<QuizzWidget> createState() => _QuizzWidgetState();
}

class _QuizzWidgetState extends State<QuizzWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.term,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          for (var answer in widget.question.answers)
            Row(
              children: [
                Checkbox(
                  value: answer == widget.selectedAnswer,
                  onChanged: (value) {
                    widget.onSelectAnswer(answer);
                  },
                ),
                Text(answer),
              ],
            ),
        ],
      ),
    );
  }
}
