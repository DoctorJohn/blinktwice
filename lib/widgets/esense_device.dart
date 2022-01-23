import 'package:esense_flutter/esense.dart';
import 'package:flutter/material.dart';

class ESenseDevice extends StatefulWidget {
  final String deviceName;

  const ESenseDevice({Key? key, required this.deviceName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ESenseDeviceState();
}

class _ESenseDeviceState extends State<ESenseDevice> {
  bool searching = false;
  bool disconnecting = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.deviceName),
        subtitle: buildSubtitle(),
        trailing: buildTrailing(),
      ),
    );
  }

  Widget buildSubtitle() {
    return StreamBuilder<ConnectionEvent>(
      stream: ESenseManager().connectionEvents,
      builder: (context, snapshot) {
        if (searching) {
          return const Text("Searching...");
        }

        if (disconnecting) {
          return const Text("Disconnecting...");
        }

        if (snapshot.hasData) {
          switch (snapshot.data!.type) {
            case ConnectionType.connected:
              return const Text("Connected!");
            case ConnectionType.unknown:
              return const Text("Unknown state.");
            case ConnectionType.disconnected:
              return const Text("Disconnected.");
            case ConnectionType.device_found:
              return const Text("Device found!");
            case ConnectionType.device_not_found:
              return const Text("Device not found.");
          }
        }

        return const Text("Not connected.");
      },
    );
  }

  Widget buildTrailing() {
    return StreamBuilder<ConnectionEvent>(
      stream: ESenseManager().connectionEvents,
      builder: (context, snapshot) {
        if (searching) {
          return const Switch(
            value: true,
            onChanged: null,
          );
        }

        if (disconnecting) {
          return const Switch(
            value: false,
            onChanged: null,
          );
        }

        if (!snapshot.hasData) {
          return Switch(
            value: false,
            onChanged: (_) => connect(),
          );
        }

        switch (snapshot.data!.type) {
          case ConnectionType.device_found:
          case ConnectionType.connected:
            return Switch(
              value: true,
              onChanged: (_) => disconnect(),
            );
          case ConnectionType.unknown:
          case ConnectionType.disconnected:
          case ConnectionType.device_not_found:
            return Switch(
              value: false,
              onChanged: (_) => connect(),
            );
        }
      },
    );
  }

  void connect() async {
    setSearching(true);
    await ESenseManager().disconnect();
    await ESenseManager().connect(widget.deviceName);
    await ESenseManager().connectionEvents.first;
    setSearching(false);
  }

  void disconnect() async {
    setDisconnecting(true);
    await ESenseManager().disconnect();
    setDisconnecting(false);
  }

  void setSearching(bool state) {
    setState(() {
      searching = state;
    });
  }

  void setDisconnecting(bool state) {
    setState(() {
      disconnecting = state;
    });
  }
}
