import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memoraisa/app/core/constants/assets.dart';
import 'package:memoraisa/app/core/constants/colors.dart';
import 'package:memoraisa/app/core/constants/global.dart';
import 'package:memoraisa/app/core/utils/extensions/theme_mode_extension.dart';
import 'package:memoraisa/app/data/services/local_storage_service.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart' show QuizzModel;
import 'package:memoraisa/app/presentation/modules/home/widgets/quizz_tile_item_widget.dart';
import 'package:memoraisa/app/presentation/modules/new_quizz/new_quizz_view.dart';
import 'package:memoraisa/app/presentation/shared/controllers/theme_controller.dart'
    show themeControllerProvider;

final allQuizzesProvider = FutureProvider<List<QuizzModel>>((ref) async {
  final service = ref.read(localStorageServiceProvider);
  return service.getQuizzes();
});

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  static const String routeName = 'home';

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            Assets.iconNoBg,
            color: context.isDarkMode ? Colors.white : AppColors.light,
          ),
        ),
        title: const Text(Global.appName),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(themeControllerProvider.notifier)
                  .updateTheme(!ref.read(themeControllerProvider).darkMode);
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    Assets.iconNoBg,
                    fit: BoxFit.contain,
                    color: context.isDarkMode
                        ? Colors.white.withAlpha(80)
                        : AppColors.light.withAlpha(80),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),
              ],
            ),
          ),
          Padding(
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
                        return QuizzTileItemWidget(quizz: quizz);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),
          ),
        ],
      ),
    );
  }
}
