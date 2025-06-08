import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/generated/translations.g.dart';

class Dialogs {
  Dialogs._();

  static Future<bool> trueFalse({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    final result = await showDialog<bool?>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop(true);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void snackBar({
    required BuildContext context,
    required String text,
    Color? color,
    int milliseconds = 2000,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color ?? Colors.white,
            border: color != null
                ? null
                : Border.all(
                    width: 1,
                    color: AppColors.light,
                  ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: color != null ? Colors.white : AppColors.light,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }

  static Future<AppLocale?> localeModalBottomSheet({
    required BuildContext context,
  }) async {
    final result = await showModalBottomSheet<AppLocale?>(
      context: context,
      builder: (_) => Column(
        children: [
          ListTile(
            title: const Text('English'),
            onTap: () => context.pop(AppLocale.en),
          ),
          ListTile(
            title: const Text('Spanish'),
            onTap: () => context.pop(AppLocale.es),
          ),
          ListTile(
            title: const Text('Catalan'),
            onTap: () => context.pop(AppLocale.ca),
          ),
        ],
      ),
    );
    return result;
  }
}
