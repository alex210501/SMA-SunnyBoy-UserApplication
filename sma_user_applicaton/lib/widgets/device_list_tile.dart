import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sma_device_model.dart';
import '../screens/edit_device_screen.dart';
import '../services/sma_device_manager.dart';

class DeviceListTile extends StatefulWidget {
  final Function? onTap;
  final SmaDevice smaDevice;

  const DeviceListTile({Key? key, required this.smaDevice, this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeviceListTileState();
}

class _DeviceListTileState extends State<DeviceListTile> {
  int tap = 0;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(widget.smaDevice.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<SmaDeviceManager>(context, listen: false)
            .removeDevice(widget.smaDevice);
      },
      background: Container(
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete)),
      child: ListTile(
        onTap: widget.onTap == null ? null : () => widget.onTap!(),
        title: Text(widget.smaDevice.name),
        subtitle: Text('${widget.smaDevice.host}:${widget.smaDevice.port}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditDeviceScreen(device: widget.smaDevice)));
          },
        ),
      ),
    );
  }
}
