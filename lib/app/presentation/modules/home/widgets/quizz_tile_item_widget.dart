import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memoraisa/app/core/utils/extensions/num_to_sizedbox.dart';
import 'package:memoraisa/app/core/utils/extensions/string_extensions.dart';
import 'package:memoraisa/app/data/services/local_storage_service.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:memoraisa/app/presentation/modules/home/home_view.dart';
import 'package:memoraisa/app/presentation/modules/quizz/quizz_view.dart';
import 'package:memoraisa/app/presentation/shared/dialogs.dart';

class QuizzTileItemWidget extends ConsumerWidget {
  const QuizzTileItemWidget({super.key, required this.quizz});

  final QuizzModel quizz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        context.pushNamed(QuizzView.routeName, extra: quizz);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withAlpha(180),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.question_answer, size: 24),
            10.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quizz.quizzName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  4.h,
                  Text(
                    '${quizz.questions.length} preguntas (${quizz.questionType.capitalize()})',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final doIt = await Dialogs.trueFalse(
                  context: context,
                  title: 'Delete quizz',
                  content: 'Do you want to delete this quizz?',
                );
                if (!doIt) return;
                await ref
                    .read(localStorageServiceProvider)
                    .deleteQuiz(quizz.quizzName);
                ref.invalidate(allQuizzesProvider);
              },
            ),
          ],
        ),
      ),
    );
  }
}
