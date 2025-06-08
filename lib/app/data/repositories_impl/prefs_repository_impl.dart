import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/enums/prefs_enum.dart';
import '../../domain/repositories/prefs_repository.dart';

class PrefsRepositoryImpl implements PrefsRepository {
  PrefsRepositoryImpl(this._sharedPrefs);

  final SharedPreferences _sharedPrefs;

  @override
  bool get isDarkMode =>
      _sharedPrefs.getBool(PrefsEnum.isDarkMode.name) ?? false;

  @override
  Future<bool> setThemeMode(bool value) async {
    return await _sharedPrefs.setBool(
      PrefsEnum.isDarkMode.name,
      value,
    );
  }

  @override
  String? get fileDataString =>
      _sharedPrefs.getString(PrefsEnum.fileDataString.name);

  @override
  Future<bool> setFileDataString(String? value) async {
    return await _sharedPrefs.setString(
      PrefsEnum.fileDataString.name,
      value ?? '',
    );
  }

  @override
  String? get responseInstructions =>
      _sharedPrefs.getString(PrefsEnum.responseInstructions.name);

  @override
  Future<bool> setResponseInstructions(String? value) async {
    return await _sharedPrefs.setString(
      PrefsEnum.responseInstructions.name,
      value ?? '',
    );
  }

  @override
  String? get responseLanguage =>
      _sharedPrefs.getString(PrefsEnum.responseLanguage.name);

  @override
  Future<bool> setResponseLanguage(String? value) async {
    return await _sharedPrefs.setString(
      PrefsEnum.responseLanguage.name,
      value ?? '',
    );
  }
}
