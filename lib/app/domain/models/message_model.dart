class MessageModel {
  final String text;
  final bool isMe;
  final bool isError;

  MessageModel({
    required this.text,
    required this.isMe,
    this.isError = false,
  });

  MessageModel copyWith({
    String? text,
    bool? isMe,
    bool? isError,
  }) =>
      MessageModel(
        text: text ?? this.text,
        isMe: isMe ?? this.isMe,
        isError: isError ?? this.isError,
      );

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        text: json["text"],
        isMe: json["isMe"],
        isError: json["isError"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "isMe": isMe,
        "isError": isError,
      };
}
