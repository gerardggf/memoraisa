import 'package:hive/hive.dart';

part 'quizz_model.g.dart';

@HiveType(typeId: 0)
class QuizzModel extends HiveObject {
  @HiveField(0)
  final String quizzName;

  @HiveField(1)
  final String questionType;

  @HiveField(2)
  final List<dynamic> questions;

  QuizzModel({
    required this.quizzName,
    required this.questions,
    required this.questionType,
  });

  factory QuizzModel.fromJson(Map<String, dynamic> json) {
    return QuizzModel(
      quizzName: json['quizzName'],
      questions: List<dynamic>.from(
        json['questionType'] == 'single'
            ? json['questions'].map((x) => SingleQuestionModel.fromJson(x))
            : json['questionType'] == 'multiple'
            ? json['questions'].map((x) => MultipleQuestionModel.fromJson(x))
            : json['questions'].map(
                (x) => TrueOrFalseQuestionModel.fromJson(x),
              ),
      ),

      questionType: json['questionType'],
    );
  }

  Map<String, dynamic> toJson() => {
    'quizzName': quizzName,
    'questionType': questionType,
    'questions': questions.map((x) {
      if (x is SingleQuestionModel) return x.toJson();
      if (x is MultipleQuestionModel) return x.toJson();
      if (x is TrueOrFalseQuestionModel) return x.toJson();
      throw Exception('Unknown question model type');
    }).toList(),
  };
}

@HiveType(typeId: 1)
class SingleQuestionModel {
  @HiveField(0)
  final String term;

  @HiveField(1)
  final List<String> answers;

  @HiveField(2)
  final String correctAnswer;

  SingleQuestionModel({
    required this.term,
    required this.answers,
    required this.correctAnswer,
  });

  factory SingleQuestionModel.fromJson(Map<String, dynamic> json) {
    return SingleQuestionModel(
      term: json['term'],
      answers: List<String>.from(json['answers']),
      correctAnswer: json['correctAnswer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': 'single',
    'term': term,
    'answers': answers,
    'correctAnswer': correctAnswer,
  };
}

@HiveType(typeId: 2)
class MultipleQuestionModel {
  @HiveField(0)
  final String term;

  @HiveField(1)
  final List<String> answers;

  @HiveField(2)
  final List<String> correctAnswers;

  MultipleQuestionModel({
    required this.term,
    required this.answers,
    required this.correctAnswers,
  });

  factory MultipleQuestionModel.fromJson(Map<String, dynamic> json) {
    return MultipleQuestionModel(
      term: json['term'],
      answers: List<String>.from(json['answers']),
      correctAnswers: List<String>.from(json['correctAnswers']),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': 'multiple',
    'term': term,
    'answers': answers,
    'correctAnswers': correctAnswers,
  };
}

@HiveType(typeId: 3)
class TrueOrFalseQuestionModel {
  @HiveField(0)
  final String term;

  @HiveField(1)
  final bool answer;

  TrueOrFalseQuestionModel({required this.term, required this.answer});

  factory TrueOrFalseQuestionModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return TrueOrFalseQuestionModel(term: json['term'], answer: json['answer']);
  }

  Map<String, dynamic> toJson() => {
    'type': 'truefalse',
    'term': term,
    'answer': answer,
  };
}
