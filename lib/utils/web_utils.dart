import 'dart:typed_data';
import 'dart:html' as html;

Future<void> downloadPdf(Uint8List data, String filename) async {
  final blob = html.Blob([data]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}