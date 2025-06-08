import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoraisa/app/core/constants/global.dart';
import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:memoraisa/app/presentation/modules/home/home_controller.dart';
import 'package:memoraisa/app/presentation/shared/dialogs.dart' show Dialogs;

class FileAndQuestionTypeSelector extends ConsumerStatefulWidget {
  final Function(File file, QuestionTypeEnum questionType) onConfirm;

  const FileAndQuestionTypeSelector({super.key, required this.onConfirm});

  @override
  ConsumerState<FileAndQuestionTypeSelector> createState() =>
      _FileAndQuestionTypeSelectorState();
}

class _FileAndQuestionTypeSelectorState
    extends ConsumerState<FileAndQuestionTypeSelector> {
  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: Global.allowedFileExtensions,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        ref
            .read(homeControllerProvider.notifier)
            .updateFile(File(result.files.single.path!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona un archivo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: pickFile,
              icon: const Icon(Icons.upload_file),
              label: Text(
                state.file != null
                    ? state.file!.path.split('/').last
                    : 'Seleccionar archivo',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Qué tipo de preguntas quieres?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: QuestionTypeEnum.values.map((type) {
                return ChoiceChip(
                  label: Text(type.text),
                  selected: state.questionType == type,
                  onSelected: (_) {
                    notifier.updateQuestionType(type);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: confirmSelection,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generar preguntas'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void confirmSelection() async {
    final state = ref.read(homeControllerProvider);
    if (state.file == null) {
      Dialogs.snackBar(context: context, text: 'Selecciona un archivo');
      return;
    }
    await ref.read(homeControllerProvider.notifier).submit();
  }
}
