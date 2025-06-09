import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:memoraisa/app/presentation/modules/new_quizz/new_quizz_view.dart';
import 'package:memoraisa/app/presentation/modules/quizz/quizz_view.dart';

import '../../core/constants/assets.dart';
import '../../core/generated/translations.g.dart';
import '../shared/widgets/error_info_widget.dart';
import '../modules/home/home_view.dart';
import '../modules/splash/splash_view.dart';

// final userLoaderFutureProvider = FutureProvider<UserModel?>((ref) async {
//   return await ref.read(sessionControllerProvider.notifier).loadRemoteUser();
// });

final goRouterProvider = Provider<GoRouter>((ref) {
  //final userLoaderState = ref.watch(userLoaderFutureProvider);
  // final userAuthState = ref.watch(sessionControllerProvider);
  return GoRouter(
    errorBuilder: (context, state) => Scaffold(
      body: ErrorInfoWidget(
        text: texts.global.pageNotFound,
        icon: Image.asset(
          Assets.iconLogo,
          width: 50,
          height: 50,
          errorBuilder: (_, _, _) => const SizedBox(),
        ),
      ),
    ),
    initialLocation: '/splash',
    routes: [
      GoRoute(
        name: SplashView.routeName,
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        name: HomeView.routeName,
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),

      GoRoute(
        name: NewQuizzView.routeName,
        path: '/new-quizz',
        builder: (context, state) => const NewQuizzView(),
      ),
      GoRoute(
        name: QuizzView.routeName,
        path: '/quizz',
        builder: (context, state) => QuizzView(state.extra as QuizzModel),
      ),
    ],
    redirect: (context, state) {
      if (state.uri.toString() == '/splash') {
        return '/home';
      }
      return null;
    },
  );
});
