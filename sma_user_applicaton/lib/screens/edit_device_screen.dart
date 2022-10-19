import 'package:flutter/material.dart';

import '../models/sma_device_model.dart';
import '../widgets/edit_device_text_form.dart';

class _ListViewContainer extends StatelessWidget {
  final String? title;
  List<Widget> children;

  _ListViewContainer({required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          title != null
              ? Text(
                  title!,
                  style: const TextStyle(fontSize: 20),
                )
              : Container(),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(10),
              child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: children))
        ]));
  }
}

class EditDeviceScreen extends StatefulWidget {
  SmaDevice smaDevice;

  EditDeviceScreen({Key? key, required device})
      : smaDevice = SmaDevice.from(device),
        super(key: key);

  @override
  State<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends State<EditDeviceScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit widget"),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Copy in file
              }
            },
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              EditDeviceTextForm(
                initialValue: widget.smaDevice.name,
                labelText: 'Device',
                hintText: 'Device name',
                validator: (value) {
                  widget.smaDevice.host = value!;
                  return null;
                },
              ),
              _ListViewContainer(title: 'Network', children: [
                EditDeviceTextForm(
                  initialValue: widget.smaDevice.host,
                  labelText: 'Host',
                  hintText: 'localhost',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Set a valid host';
                    }
                    widget.smaDevice.host = value;
                    return null;
                  },
                ),
                EditDeviceTextForm(
                  initialValue: widget.smaDevice.port.toString(),
                  labelText: 'Port',
                  hintText: '5000',
                  validator: (value) {
                    final port = num.tryParse(value!);

                    if ((port == null) || (port < 1) || (port > 65535)) {
                      return 'Set a port between 0 and 65535';
                    }

                    widget.smaDevice.port = port.toInt();
                    return null;
                  },
                )
              ]),
              _ListViewContainer(title: 'Authentication', children: [
                EditDeviceTextForm(
                  initialValue: widget.smaDevice.username,
                  labelText: 'Username',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Set a valid username';
                    }
                    widget.smaDevice.username = value;
                    return null;
                  },
                ),
                EditDeviceTextFormPassword(
                  initialValue: widget.smaDevice.password,
                  labelText: 'Password',
                  validator: (value) {
                    widget.smaDevice.password = value!;
                    return null;
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EditDeviceScreen(
        device: SmaDevice.defaultInstance(),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
