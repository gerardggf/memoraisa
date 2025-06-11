import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memoraisa/app/core/constants/assets.dart';
import 'package:memoraisa/app/core/constants/global.dart';
import 'package:memoraisa/app/core/utils/extensions/theme_mode_extension.dart';
import 'package:memoraisa/app/data/services/local_storage_service.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart' show QuizzModel;
import 'package:memoraisa/app/presentation/modules/new_quizz/new_quizz_view.dart';
import 'package:memoraisa/app/presentation/modules/quizz/quizz_view.dart';
import 'package:memoraisa/app/presentation/shared/controllers/theme_controller.dart'
    show themeControllerProvider;
import 'package:memoraisa/app/presentation/shared/dialogs.dart';

final allQuizzesProvider = FutureProvider<List<QuizzModel>>((ref) async {
  final service = ref.read(localStorageServiceProvider);
  return service.getQuizzes();
});

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const String routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(3).copyWith(left: 10),
          child: ClipOval(child: Image.asset(Assets.iconLogo)),
        ),
        title: const Text(Global.appName),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(themeControllerProvider.notifier)
                  .updateTheme(!context.isDarkMode);
            },
            icon: Icon(context.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          context.pushNamed(NewQuizzView.routeName);
        },
        child: const Text('New quizz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ref
            .watch(allQuizzesProvider)
            .when(
              data: (quizzes) {
                if (quizzes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pushNamed(NewQuizzView.routeName);
                          },
                          icon: Icon(Icons.add, size: 50),
                        ),
                        Text(
                          'No quizzes yet.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quizz = quizzes[index];
                    return ListTile(
                      leading: Icon(Icons.question_answer),
                      trailing: IconButton(
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
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                      title: Text(quizz.quizzName),
                      subtitle: Text('${quizz.questions.length} preguntas'),
                      onTap: () {
                        context.pushNamed(QuizzView.routeName, extra: quizz);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
      ),
    );
  }
}
