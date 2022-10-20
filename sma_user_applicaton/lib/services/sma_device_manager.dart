import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/sma_device_model.dart';
import '../utils/file_manager.dart';

const String devicesFilePath = 'configurations/devices.json';

/// Class that manage the existing device
class SmaDeviceManager extends ChangeNotifier {
  final List<SmaDevice> _devices = <SmaDevice>[];

  /// Get an unmodifiable list of [SmaDevice]
  List<SmaDevice> get devices => List.unmodifiable(_devices);

  /// Must called at start
  /// Used to load the device that already exists in the [deviceFilePath]
  /// path
  Future<void> createDevicesFromFile() async {
    List<dynamic> jsonData = await _loadDevicesFromFile();

    for (var jsonDevice in jsonData) {
      _devices.add(SmaDevice.fromJson(jsonDevice));
    }

    notifyListeners();
  }

  /// Add a [device] in the list and edit it if it is already in the list
  void addDevice(SmaDevice device) async {
    /// If the device is in the list, edit it
    /// Otherwise, add it
    if (_devices.contains(device)) {
      SmaDevice deviceFound = _devices.firstWhere((item) => item == device);
      deviceFound.copy(device);
    } else {
      _devices.add(device);
    }

    /// Update the file
    await FileManager.writeFileToDocuments(devicesFilePath, jsonEncode(this));
    notifyListeners();
  }

  /// Remove the specific [device]
  /// Throw an exception if the device is not in the list
  void removeDevice(SmaDevice device) {
    if (!_devices.contains(device)) {
      throw Exception('The device with id ${device.id} is not on the list !');
    }

    /// Remove device and update the file
    _devices.removeWhere((item) => item == device);
    FileManager.writeFileToDocuments(devicesFilePath, jsonEncode(this));
    notifyListeners();
  }

  /// Return a JSON representation of the class
  List<Map> toJson() {
    List<Map> jsonDevices = [];

    for (final SmaDevice device in _devices) {
      jsonDevices.add(device.toJson());
    }

    return jsonDevices;
  }

  /// Return a list with the devices that exists on the configuration file
  Future<List> _loadDevicesFromFile() async {
    try {
      String content = await FileManager.readFileFromDocuments(devicesFilePath);

      return jsonDecode(content);
    } on FileSystemException{
      /// If an error occured during the read, it means that the file does not exists
      /// Then, we create it
      await FileManager.writeFileToDocuments(devicesFilePath, '[]');
    } on JsonUnsupportedObjectError {
      await FileManager.writeFileToDocuments(devicesFilePath, '[]');
    }

    return [];
  }
}


/// Main function to test the class
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SmaDeviceManager smaDeviceManager = SmaDeviceManager();

  await smaDeviceManager.createDevicesFromFile();
}