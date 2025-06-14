import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoraisa/app/presentation/shared/controllers/theme_controller.dart';

import '../main.dart';
import 'core/constants/global.dart';
import 'core/generated/translations.g.dart';
import 'presentation/shared/widgets/error_info_widget.dart';
import 'presentation/shared/widgets/loading_widget.dart';
import 'presentation/routes/router.dart';
import 'presentation/shared/theme.dart';

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      data: (_) => const MemoraisaApp(),
      error: (e, _) => ErrorInfoWidget(text: e.toString()),
      loading: () => const LoadingWidget(),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ErrorInfoWidget());
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Center(child: LoadingWidget()));
  }
}

class MemoraisaApp extends ConsumerStatefulWidget {
  const MemoraisaApp({super.key});

  @override
  ConsumerState<MemoraisaApp> createState() => _TeamTrackAppState();
}

class _TeamTrackAppState extends ConsumerState<MemoraisaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Global.appName,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(ref.watch(themeControllerProvider).darkMode),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
