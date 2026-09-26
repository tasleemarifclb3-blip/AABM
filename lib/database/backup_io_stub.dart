import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Web implementation. Chrome owns the final download/save location, so the
/// native-style folder API is not used here. FilePicker's save dialog lets the
/// user choose the destination when the browser/platform supports it.
Future<String?> saveNativeBackup({
  required Uint8List bytes,
  required String fileName,
  required bool chooseLocation,
}) async {
  final saved = await FilePicker.saveFile(
    dialogTitle: chooseLocation ? 'Save AABM Backup' : 'Save Latest AABM Backup',
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: const ['json'],
    bytes: bytes,
  );
  return saved?.toString();
}
