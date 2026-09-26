import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Native implementation of backup saving.
///
/// On Android/Windows:
/// - chooseLocation = false:
///     Saves automatically in the application's support directory.
/// - chooseLocation = true:
///     Asks the user to select a folder.
///
/// Web uses backup_io_stub.dart instead.
Future<String?> saveNativeBackup({
  required Uint8List bytes,
  required String fileName,
  required bool chooseLocation,
}) async {
  String directoryPath;

  if (chooseLocation) {
    final selected = await FilePicker.getDirectoryPath();

    if (selected == null || selected.trim().isEmpty) {
      return null;
    }

    directoryPath = selected;
  } else {
    final directory = await getApplicationSupportDirectory();
    directoryPath = directory.path;
  }

  final directory = Directory(directoryPath);

  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final file = File(
    '${directory.path}${Platform.pathSeparator}$fileName',
  );

  await file.writeAsBytes(bytes, flush: true);

  return file.path;
}