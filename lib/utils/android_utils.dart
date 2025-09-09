// utils/mobile_pdf_saver.dart
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> downloadPdf(Uint8List data, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/$filename");
  await file.writeAsBytes(data);
  OpenFile.open(file.path);
}