import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

class LocalStorageService {
  static const _boxName = 'quizzes';

  /// Devuelve todos los quizzes guardados
  Future<List<QuizzModel>> getQuizzes() async {
    final box = await Hive.openBox<QuizzModel>(_boxName);
    return box.values.toList();
  }

  /// Guarda un quiz
  Future<void> saveQuiz(QuizzModel quiz) async {
    final box = await Hive.openBox<QuizzModel>(_boxName);
    await box.put(quiz.quizzName, quiz);
  }

  /// Elimina un quiz por nombre
  Future<void> deleteQuiz(String quizzName) async {
    final box = await Hive.openBox<QuizzModel>(_boxName);
    await box.delete(quizzName);
  }

  /// Limpia todos los quizzes
  Future<void> clearQuizzes() async {
    final box = await Hive.openBox<QuizzModel>(_boxName);
    await box.clear();
  }
}
