// ADAPTADO PARA WEB Y MÓVIL
import 'dart:convert' show utf8, json;
import 'dart:typed_data';
import 'package:archive/archive_io.dart' show ZipDecoder;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memoraisa/app/core/constants/urls.dart';
import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:memoraisa/app/core/utils/failure/failure.dart';
import 'package:memoraisa/app/core/utils/typedefs.dart';
import 'package:memoraisa/app/data/services/local_storage_service.dart';
import 'package:memoraisa/app/domain/models/quizz_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, compute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart' show XmlDocument, XmlFindExtension;
import '../../core/providers.dart';
import '../../core/utils/either/either.dart';

final apiServiceProvider = Provider<ApiService>(
  (ref) =>
      ApiService(ref.read(dioProvider), ref.read(localStorageServiceProvider)),
);

class ApiService {
  ApiService(this.dio, this.localStorageService);

  final Dio dio;
  final LocalStorageService localStorageService;

  final String url = Urls.promptEndpoint;
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  static String extractTextFromBytes(Uint8List bytes, String filename) {
    final lowerPath = filename.toLowerCase();

    if (lowerPath.endsWith('.txt') ||
        lowerPath.endsWith('.json') ||
        lowerPath.endsWith('.csv')) {
      return utf8.decode(bytes);
    }

    if (lowerPath.endsWith('.pdf')) {
      final document = PdfDocument(inputBytes: bytes);
      String content = PdfTextExtractor(document).extractText();
      document.dispose();
      return content;
    }

    if (lowerPath.endsWith('.docx')) {
      final archive = ZipDecoder().decodeBytes(bytes);
      final xmlFile = archive.firstWhere((f) => f.name == 'word/document.xml');
      final xml = XmlDocument.parse(utf8.decode(xmlFile.content));
      return xml.findAllElements('w:t').map((e) => e.value).join(' ');
    }

    throw Exception('Formato de archivo no soportado');
  }

  AsyncResult<QuizzModel> sendPrompt({
    required Uint8List? fileBytes,
    required String? fileName,
    required QuestionTypeEnum questionType,
  }) async {
    if (fileBytes == null || fileName == null) {
      return Either.left(Failure('No file selected'));
    }

    final fileContent = await compute(_computeExtractText, [
      fileBytes,
      fileName,
    ]);

    final systemPrompt =
        '''Responde siempre en español y únicamente con un JSON con el siguiente formato para cada pregunta, basado en la información que te será proporcionada:
{
  "quizzName": "(nombre del archivo)",
  "questions": [
    {
      "term": "(pregunta 1)",
      "answers": ["(respuesta 1)", "(respuesta 2)", "(respuesta 3)"],
      "correctAnswer": "(respuesta correcta identica a la listada en answers)"
    }
  ]
}''';

    final userPrompt =
        'Dame 10 preguntas sacadas del siguiente contenido: "$fileContent". Haz que las respuestas no estén ordenadas.';

    try {
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
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": userPrompt},
          ],
        },
      );

      if (kDebugMode) print(response.data);

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content']
            .toString();
        final jsonString = _extractJsonBlock(content);
        final quizz = json.decode(jsonString) as Map<String, dynamic>;
        final result = QuizzModel.fromJson(quizz);
        await localStorageService.saveQuiz(result);
        return Either.right(result);
      } else {
        return Either.left(Failure('Status code: \${response.statusCode}'));
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return Either.left(Failure(e.toString()));
    }
  }

  static String _computeExtractText(List<dynamic> args) {
    final bytes = args[0] as Uint8List;
    final filename = args[1] as String;
    return extractTextFromBytes(bytes, filename);
  }

  String _extractJsonBlock(String text) {
    final regex = RegExp(r'{.*}', dotAll: true);
    final match = regex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }
    throw Exception('No se pudo extraer el bloque JSON válido');
  }
}
