import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sma_device_model.dart';
import '../screens/edit_device_screen.dart';
import '../services/sma_device_manager.dart';
import '../widgets/device_list_tile.dart';

class SelectDeviceScreen extends StatefulWidget {
  const SelectDeviceScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectDeviceScreenState();
}

class _SelectDeviceScreenState extends State<SelectDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    final SmaDeviceManager deviceManager =
        Provider.of<SmaDeviceManager>(context, listen: false);

    return FutureBuilder(
        future: deviceManager.createDevicesFromFile(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return Scaffold(
              appBar: AppBar(title: const Text('Devices'), actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditDeviceScreen(
                                device: SmaDevice.defaultInstance())));
                  },
                ),
              ]),
              body: Consumer<SmaDeviceManager>(builder: (context, _, __) {
                return ListView.separated(
                    itemCount: deviceManager.devices.length,
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return DeviceListTile(
                          smaDevice: deviceManager.devices[index]);
                    });
              }));
        });
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
      home: const SelectDeviceScreen(),
    );
  }
}

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => SmaDeviceManager(), child: const MyApp()));
}
