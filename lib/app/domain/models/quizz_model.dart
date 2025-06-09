import 'package:hive/hive.dart';

part 'quizz_model.g.dart';

@HiveType(typeId: 0)
class QuizzModel extends HiveObject {
  @HiveField(0)
  final String quizzName;

  @HiveField(1)
  final List<QuestionModel> questions;

  QuizzModel({required this.quizzName, required this.questions});

  factory QuizzModel.fromJson(Map<String, dynamic> json) {
    return QuizzModel(
      quizzName: json['quizzName'],
      questions: List<QuestionModel>.from(
        json['questions'].map((x) => QuestionModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'quizzName': quizzName,
    'questions': questions.map((x) => x.toJson()).toList(),
  };
}

@HiveType(typeId: 1)
class QuestionModel extends HiveObject {
  @HiveField(0)
  final String term;

  @HiveField(1)
  final List<String> answers;

  @HiveField(2)
  final String correctAnswer;

  QuestionModel({
    required this.term,
    required this.answers,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      term: json['term'],
      answers: List<String>.from(json['answers']),
      correctAnswer: json['correctAnswer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'term': term,
    'answers': answers,
    'correctAnswer': correctAnswer,
  };
}
