import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stream_testing/models/gesture.dart';
import 'package:stream_testing/widgets/confirmation_dialog.dart';

class GesturesCard extends StatefulWidget {
  const GesturesCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GesturesCardState();
}

class _GesturesCardState extends State<GesturesCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ValueListenableBuilder<Box<Gesture>>(
        valueListenable: Hive.box<Gesture>('gestures').listenable(),
        builder: _buildList,
      ),
    );
  }

  Widget _buildList(BuildContext context, Box<Gesture> box, Widget? _) {
    final gestures = box.values.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: gestures.length,
      itemBuilder: (nestedContext, index) {
        final gesture = gestures[index];

        return ListTile(
          title: Text("${gesture.caller!} (${gesture.number!})"),
          subtitle: Text(gesture.gesture!.toUpperCase()),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDeleteConfirmationDialog(context, gesture),
          ),
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, Gesture gesture) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Delete gesture",
        content: "Are you sure you want to delete this gesture?",
        confirmLabel: "Delete",
        onConfirmation: () => gesture.delete(),
      ),
    );
  }
}
