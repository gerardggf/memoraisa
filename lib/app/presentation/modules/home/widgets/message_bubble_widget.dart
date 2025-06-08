import 'package:memoraisa/app/domain/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ).copyWith(
          left: message.isMe ? 30 : 10,
          right: message.isMe ? 10 : 30,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isError
              ? Colors.red.withAlpha(50)
              : message.isMe
                  ? Colors.teal.shade100
                  : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8),
            topRight: const Radius.circular(8),
            bottomLeft: message.isMe ? const Radius.circular(8) : Radius.zero,
            bottomRight: message.isMe ? Radius.zero : const Radius.circular(8),
          ),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
