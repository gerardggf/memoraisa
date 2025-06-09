import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';

import 'app/core/generated/translations.g.dart';
import 'app/core/providers.dart';
import 'app/accb_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await LocaleSettings.useDeviceLocale();

  await Hive.initFlutter();
  Hive.registerAdapter(QuizzModelAdapter());
  Hive.registerAdapter(QuestionModelAdapter());
  await Hive.openBox<QuizzModel>('quizzes');

  runApp(
    ProviderScope(child: TranslationProvider(child: const AppStartupWidget())),
  );
}

final appStartupProvider = FutureProvider<void>((ref) async {
  ref.onDispose(() {
    ref.invalidate(sharedPreferencesProvider);
    ref.invalidate(packageInfoProvider);
  });
  await ref.watch(sharedPreferencesProvider.future);
  await ref.watch(packageInfoProvider.future);
});
