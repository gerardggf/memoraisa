import 'package:flutter/material.dart';
import 'package:memoraisa/app/presentation/modules/new_quizz/widgets/file_question_selector_widget.dart';

class NewQuizzView extends StatelessWidget {
  const NewQuizzView({super.key});

  static const routeName = '/new-quizz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New quizz')),
      body: FileAndQuestionTypeSelector(),
    );
  }
}
