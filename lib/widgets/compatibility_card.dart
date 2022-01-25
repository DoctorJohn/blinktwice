import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';

class CompatibilityCard extends StatelessWidget {
  const CompatibilityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<bool>(
        future: isDeviceSupported(),
        builder: (context, snapshot) {
          final subtitle = snapshot.hasData
              ? snapshot.data!
                  ? const Text("Device compatible")
                  : const Text("Device incompatible")
              : const Text("Checking...");

          final problem = snapshot.hasData && !snapshot.data!;

          return ListTile(
            title: const Text("Device compatibility"),
            subtitle: subtitle,
            trailing: IconButton(
              icon: Icon(problem ? Icons.warning : Icons.check),
              onPressed: null,
            ),
          );
        },
      ),
    );
  }

  Future<bool> isDeviceSupported() async {
    return (await CallKeep.isCurrentDeviceSupported) ?? false;
  }
}
