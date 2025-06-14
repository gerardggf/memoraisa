class Global {
  Global._();

  static const String appName = 'Memoraisa';

  static const String responseInstructions =
      'You are an angry customer who has not received a food order yet';

  static const List<String> allowedFileExtensions = [
    'txt',
    'pdf',
    'docx',
    'json',
    'csv',
  ];

  static const int maxCharacters = 20000;

  static const List<int> numberOfQuestionsList = [5, 10, 20, 30];

  static const int defaultNumberOfQuestions = 10;
}
