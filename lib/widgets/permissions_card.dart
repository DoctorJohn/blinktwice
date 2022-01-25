import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsCard extends StatefulWidget {
  const PermissionsCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PermissionsCardState();
}

class _PermissionsCardState extends State<PermissionsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<bool>(
        future: Permission.phone.isGranted,
        builder: (context, snapshot) {
          final subtitle = snapshot.hasData
              ? snapshot.data!
                  ? const Text("Permission granted")
                  : const Text("Permission denied")
              : const Text("Checking...");

          final enabled = snapshot.hasData && !snapshot.data!;

          debugPrint("SNAPSHOT: $snapshot");

          return ListTile(
            title: const Text("Call permissions"),
            subtitle: subtitle,
            trailing: IconButton(
              icon: const Icon(Icons.security),
              onPressed: enabled
                  ? () async {
                      CallKeep.askForPermissionsIfNeeded(context);
                      // Trigger rebuild to show new permission status
                      setState(() {});
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}
