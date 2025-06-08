import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories_impl/prefs_repository_impl.dart';

final prefsRepoProvider = Provider<PrefsRepository>(
  (ref) => PrefsRepositoryImpl(
    ref.watch(sharedPreferencesProvider).requireValue,
  ),
);

abstract class PrefsRepository {
  bool get isDarkMode;
  Future<bool> setThemeMode(bool isDarkMode);

  String? get fileDataString;
  Future<bool> setFileDataString(String? fileDataString);

  String? get responseInstructions;
  Future<bool> setResponseInstructions(String? responseInstructions);

  String? get responseLanguage;
  Future<bool> setResponseLanguage(String? responseLanguage);
}
