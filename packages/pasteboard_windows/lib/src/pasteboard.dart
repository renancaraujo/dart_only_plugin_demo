import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:pasteboard_interface/pasteboard_interface.dart';
import 'package:pasteboard_windows/pasteboard_windows.dart';
import 'package:win32/win32.dart';

class PasteboardWindows implements PasteboardInterface {
  bool writeStringForFormat(String string, Format format) {
    final hGlobal = GlobalAlloc(
      0x0002 /* GMEM_MOVEABLE */,
      string.length * 2 + 2,
    );

    final lpData = GlobalLock(hGlobal).cast<Utf16>();
    if (lpData == nullptr) {
      return false;
    }

    lpData.setString(string);

    GlobalUnlock(hGlobal);

    if (OpenClipboard(NULL) != 0) {
      EmptyClipboard();
      SetClipboardData(format.value, hGlobal.address);
      CloseClipboard();
    }

    GlobalFree(hGlobal);

    return true;
  }

  String? readStringForFormat(Format format) {
    String? result;
    if (OpenClipboard(NULL) != 0) {
      if (IsClipboardFormatAvailable(CF_TEXT) != 0) {
        final hData = GetClipboardData(CF_TEXT);
        if (hData != NULL) {
          final lpData = GlobalLock(Pointer.fromAddress(hData));
          if (lpData != nullptr) {
            final text = lpData.cast<Utf8>().toDartString();
            result = text;
            GlobalUnlock(Pointer.fromAddress(hData));
          }
        }
      }

      CloseClipboard();
    }
    return result;
  }

  @override
  bool writeString(String string) {
    try {
      return writeStringForFormat(string, Format.text);
    } catch (e) {
      return false;
    }
  }

  @override
  String? readString() {
    return readStringForFormat(Format.text);
  }
}
