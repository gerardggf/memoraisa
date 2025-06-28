enum QuestionTypeEnum {
  single,
  multiple,
  //trueFalse
}

extension QuestionTypeEnumExtension on QuestionTypeEnum {
  String get text {
    switch (this) {
      case QuestionTypeEnum.single:
        return 'Single';
      case QuestionTypeEnum.multiple:
        return 'Multiple';
      // case Questi false';
    }
  }
}
