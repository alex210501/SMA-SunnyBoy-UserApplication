import 'package:flutter/material.dart';

import '../models/sma_data_model.dart';
import '../models/sma_device_model.dart';
import '../providers/sma_api.dart';
import '../utils/stream_periodic.dart';
import '../widgets/gauge.dart';
import '../widgets/listview_container_with_title.dart';

class DeviceDataScreen extends StatefulWidget {
  final SmaDevice smaDevice;

  const DeviceDataScreen(this.smaDevice, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeviceDataScreenState();
}

class _DeviceDataScreenState extends State<DeviceDataScreen> {
  late SmaApi smaApi;
  SmaData smaData = SmaData.defaultInstance();

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    /// Initialise here because [widget] can't be called from a constructor
    smaApi = SmaApi(widget.smaDevice);
    smaApi.login().then((_) {
      StreamPeriodic<SmaData>(2000, smaApi.getValues).listen((value) {
        setState(() {
          smaData = value;
        });
      }, onError: (error) async {
        print(error);
        await smaApi.login();
      });
    }).catchError((e) {
      Navigator.pop(context);
      print(e);
      return -1;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.smaDevice.name),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_outlined),
          onPressed: () {
            smaApi.logout().then((_) => Navigator.pop(context));
          },
        ),
      ),
      body: Center(
          child: ListView(
        children: [
          ListViewContainerWithTitle(title: 'Current power', children: [
            SizedBox(
                height: 100.0,
                width: 100.0,
                child: Container(
                  alignment: Alignment.center,
                    child: Gauge(
                  value: smaData.power.value.toDouble(),
                  radius: 70,
                  text: '${smaData.power.value} ${smaData.power.unit}',
                  maxValue: 2000,
                  minValue: 0,
                )))
          ]),
          ListViewContainerWithTitle(title: "Power", children: [
            Text(
                "Today ${smaData.energyToday.value} ${smaData.energyToday.unit}"),
            Text(
                "Total ${smaData.energyTotal.value} ${smaData.energyTotal.unit}")
          ]),
          ListViewContainerWithTitle(title: "Phase 1", children: [
            Text(
                "Frequency ${smaData.frequency.value} ${smaData.frequency.unit}"),
            Text("Power ${smaData.l1Power.value} ${smaData.l1Power.unit}"),
            Text(
                "Voltage ${smaData.l1Voltage.value} ${smaData.l1Voltage.unit}"),
            Text("Current ${smaData.l1Current.value} ${smaData.l1Current.unit}")
          ]),
          ListViewContainerWithTitle(title: "DC", children: [
            Text("Power ${smaData.dcPower.value} ${smaData.dcPower.unit}"),
            Text(
                "Voltage ${smaData.dcVoltage.value} ${smaData.dcVoltage.unit}"),
            Text("Current ${smaData.dcCurrent.value} ${smaData.dcCurrent.unit}")
          ]),
          ListViewContainerWithTitle(title: "Server", children: [
            Text(
                "Ethernet IP ${smaData.ethernetIp.value} ${smaData.ethernetIp.unit}"),
            Text("WLAN IP ${smaData.wlanIp.value} ${smaData.wlanIp.unit}"),
            Text(
                "Operating time ${smaData.operatingTime.value} ${smaData.operatingTime.unit}")
          ])
        ],
      )),
    );
  }
}

class MyApp extends StatelessWidget {
  final SmaDevice smaDevice;

  const MyApp(this.smaDevice, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceDataScreen(smaDevice),
    );
  }
}

void main() {
  runApp(MyApp(SmaDevice(
      name: "SMA Test",
      host: "https://192.168.1.151",
      port: 5000,
      username: "dummy",
      password: "1234")));
}
