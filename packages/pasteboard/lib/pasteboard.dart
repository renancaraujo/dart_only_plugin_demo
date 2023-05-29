import 'dart:io';

import 'package:pasteboard_interface/pasteboard_interface.dart';
import 'package:pasteboard_macos/pasteboard_macos.dart';
import 'package:pasteboard_windows/pasteboard_windows.dart';

PasteboardInterface getPasteboard() {
  if (Platform.isWindows) {
    return PasteboardWindows();
  } else if (Platform.isMacOS) {
    return PasteboardMacos.general;
  } else {
    throw UnsupportedError('This platform is not supported.');
  }
}
