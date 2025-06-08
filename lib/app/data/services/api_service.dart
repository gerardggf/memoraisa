import 'dart:convert' show utf8;
import 'dart:io' show File;

import 'package:archive/archive_io.dart' show ZipDecoder;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memoraisa/app/core/constants/urls.dart';
import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:memoraisa/app/core/utils/failure/failure.dart';
import 'package:memoraisa/app/core/utils/typedefs.dart';
import 'package:memoraisa/app/domain/models/message_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_text/pdf_text.dart' show PDFDoc;
import 'package:xml/xml.dart' show XmlDocument, XmlFindExtension;

import '../../core/providers.dart';
import '../../core/utils/either/either.dart';

final apiServiceProvider = Provider<ApiService>(
  (ref) => ApiService(ref.read(dioProvider)),
);

class ApiService {
  ApiService(this.dio);

  final Dio dio;

  final String url = Urls.promptEndpoint;
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  Future<String> extractText(File file) async {
    final path = file.path.toLowerCase();

    if (path.endsWith('.txt') ||
        path.endsWith('.json') ||
        path.endsWith('.csv')) {
      return await file.readAsString();
    }

    if (path.endsWith('.pdf')) {
      final doc = await PDFDoc.fromFile(file);
      return await doc.text;
    }

    if (path.endsWith('.docx')) {
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      final xmlFile = archive.firstWhere((f) => f.name == 'word/document.xml');
      final xml = XmlDocument.parse(utf8.decode(xmlFile.content));
      return xml.findAllElements('w:t').map((e) => e.value).join(' ');
    }

    throw Exception('Formato de archivo no soportado');
  }

  AsyncResult<MessageModel> sendPrompt({
    required File? file,
    required QuestionTypeEnum questionType,
  }) async {
    if (file == null) {
      return Either.left(Failure('No file selected'));
    }
    final fileContent = await extractText(file);
    try {
      if (kDebugMode) {
        print(questionType);
      }
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
        ),
        data: {
          'model': 'llama-3.3-70b-versatile',
          "messages": [
            {"role": "system", "content": questionType},
            {"role": "user", "content": fileContent},
          ],
        },
      );

      if (response.statusCode == 200) {
        return Either.right(
          MessageModel(
            text: response.data['choices'][0]['message']['content'],
            isMe: false,
          ),
        );
      } else {
        return Either.left(Failure('Status code: ${response.statusCode}'));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Either.left(Failure(e.toString()));
    }
  }
}
