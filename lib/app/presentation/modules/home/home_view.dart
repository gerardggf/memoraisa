import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memoraisa/app/core/constants/global.dart';
import 'package:memoraisa/app/core/utils/extensions/theme_mode_extension.dart';
import 'package:memoraisa/app/presentation/modules/new_quizz/new_quizz_view.dart'
    show NewQuizzView;
import 'package:memoraisa/app/presentation/shared/controllers/theme_controller.dart'
    show themeControllerProvider;

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const String routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
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
      body: ElevatedButton(
        onPressed: () {
          context.pushNamed(NewQuizzView.routeName);
        },
        child: const Text('New quizz'),
      ),
    );
  }
}
