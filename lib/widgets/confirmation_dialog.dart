import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmLabel;
  final VoidCallback onConfirmation;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.onConfirmation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(confirmLabel),
          onPressed: () {
            onConfirmation();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
