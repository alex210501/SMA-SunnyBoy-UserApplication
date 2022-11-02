import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sma_device_model.dart';
import '../services/sma_device_manager.dart';
import '../widgets/edit_device_text_form.dart';
import '../widgets/listview_container.dart';

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
                Provider.of<SmaDeviceManager>(context, listen: false)
                    .addDevice(widget.smaDevice);
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
                  widget.smaDevice.name = value!;
                  return null;
                },
              ),
              ListViewContainer(title: 'Network', children: [
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
              ListViewContainer(title: 'Authentication', children: [
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
  runApp(ChangeNotifierProvider(
      create: (context) => SmaDeviceManager(), child: const MyApp()));
}
