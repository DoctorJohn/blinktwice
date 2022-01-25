import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stream_testing/models/gesture.dart';

class GestureCreationScreen extends StatefulWidget {
  const GestureCreationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GestureCreationScreenState();
}

class _GestureCreationScreenState extends State<GestureCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final callerController = TextEditingController();
  final numberController = TextEditingController();
  final gestureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add gesture"),
        actions: _buildActions(context),
      ),
      body: _buildBody(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final box = Hive.box<Gesture>('gestures');
            final gesture = Gesture()
              ..caller = callerController.text
              ..number = numberController.text
              ..gesture = gestureController.text;
            box.add(gesture);
            Navigator.of(context).pop();
          }
        },
      ),
    ];
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextFormField(
            controller: callerController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: "Caller",
            ),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: numberController,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: "Number",
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              return null;
            },
          ),
          TextFormField(
            controller: gestureController,
            decoration: const InputDecoration(
              icon: Icon(Icons.gesture),
              labelText: "Gesture",
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
