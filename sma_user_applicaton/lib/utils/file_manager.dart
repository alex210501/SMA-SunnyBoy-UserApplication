import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

const String assetsDirectory = 'assets';


/// Class that manage the read and write process to a file
class FileManager {
  static Future<String> get localPath async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  static Future<String> readFileFromAssets(String path) async {
    return await rootBundle.loadString('$assetsDirectory/$path');
  }

  static Future<String> readFileFromDocuments(String path) async {
    final String localPath = await FileManager.localPath;
    final String filePath = '$localPath/$path';

    return await File(filePath).readAsString();
  }

  static Future<void> writeFileToDocuments(String path, String content) async {
    final String localPath = await FileManager.localPath;
    final String filePath = '$localPath/$path';

    File file = File(filePath);

    /// If the file does not exists, create it
    if (!(await File(filePath).exists())) {
      await file.create(recursive: true);
    }

    // Write and close the file
    file.writeAsStringSync(content);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileManager.writeFileToDocuments('configurations/devices.json','{"a": "b"}');
  print(await FileManager.readFileFromDocuments('configurations/devices.json'));
}