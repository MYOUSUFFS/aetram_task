import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void downloadJson(String fileName, Map<String, dynamic> data) {
  try {
    // Convert the data to a JSON string
    final jsonString = jsonEncode(data);

    // Create a blob from the JSON string
    final blob = html.Blob([jsonString], 'application/json');

    // Create a URL for the blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and set its attributes
    // ignore: unused_local_variable
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    // Clean up the URL object
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    // ignore: avoid_print
    print('Error downloading file: $e');
  }
}
