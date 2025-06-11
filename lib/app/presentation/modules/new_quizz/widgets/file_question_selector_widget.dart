import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memoraisa/app/core/constants/colors.dart';
import 'package:memoraisa/app/core/constants/global.dart';
import 'package:memoraisa/app/core/question_type_enum.dart';
import 'package:memoraisa/app/core/utils/extensions/theme_mode_extension.dart';
import 'package:memoraisa/app/presentation/modules/home/home_controller.dart';
import 'package:memoraisa/app/presentation/modules/home/home_view.dart';
import 'package:memoraisa/app/presentation/shared/dialogs.dart' show Dialogs;

class FileAndQuestionTypeSelector extends ConsumerStatefulWidget {
  const FileAndQuestionTypeSelector({super.key});

  @override
  ConsumerState<FileAndQuestionTypeSelector> createState() =>
      _FileAndQuestionTypeSelectorState();
}

class _FileAndQuestionTypeSelectorState
    extends ConsumerState<FileAndQuestionTypeSelector> {
  void pickFile() async {
    final notifier = ref.read(homeControllerProvider.notifier);
    try {
      notifier.updateFileFetching(true);
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: Global.allowedFileExtensions,
      );
      if (result != null && result.files.single.path != null) {
        notifier.updateFile(
          result.files.single.bytes!,
          result.files.single.name,
        );
      }
      notifier.updateFileFetching(false);
    } catch (_) {
      notifier.updateFileFetching(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);
    return AbsorbPointer(
      absorbing: state.fetching,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona un archivo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: pickFile,
                icon: state.fileFetching
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: context.isDarkMode
                              ? Colors.black
                              : AppColors.light,
                        ),
                      )
                    : Icon(
                        state.file != null ? Icons.check : Icons.upload_file,
                        size: 20,
                      ),
                label: Text(
                  state.fileFetching
                      ? 'Loading...'
                      : state.file != null
                      ? state.fileName!
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
                    checkmarkColor: Colors.white,
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
                  icon: ref.watch(homeControllerProvider).fetching
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: context.isDarkMode
                                ? Colors.black
                                : Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.auto_awesome,
                          size: 20,
                          color: context.isDarkMode
                              ? Colors.black
                              : Colors.white,
                        ),
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
      ),
    );
  }

  void confirmSelection() async {
    final state = ref.read(homeControllerProvider);
    if (state.fetching) return;

    final notifier = ref.read(homeControllerProvider.notifier);

    if (state.file == null) {
      Dialogs.snackBar(context: context, text: 'Selecciona un archivo');
      return;
    }

    final result = await notifier.submit();

    if (!mounted) return;

    result.when(
      left: (failure) {
        Dialogs.snackBar(context: context, text: 'Error: ${failure.message}');
      },
      right: (_) {
        ref.invalidate(allQuizzesProvider);
        context.pop();
      },
    );
  }
}
