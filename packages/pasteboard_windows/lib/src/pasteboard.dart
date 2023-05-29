import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

void main2() {
  if (OpenClipboard(NULL) != 0) {
    if (IsClipboardFormatAvailable(CF_TEXT) != 0) {
      final hData = GetClipboardData(CF_TEXT);
      if (hData != NULL) {
        final lpData = GlobalLock(Pointer.fromAddress(hData));
        if (lpData != nullptr) {
          final text = lpData.cast<Utf8>().toDartString();
          print('Clipboard Text: $text');
          GlobalUnlock(Pointer.fromAddress(hData));
        }
      }
    }

    CloseClipboard();
  }
}

void main() {
  final user32 = DynamicLibrary.open('user32.dll');

  final textToCopy = 'Hello, clipboard!';


  final hGlobal = GlobalAlloc(
    0x0002 /* GMEM_MOVEABLE */,
    textToCopy.length * 2 + 2,
  );
  final lpData = GlobalLock(hGlobal).cast<Utf16>();
  if (lpData == nullptr) {
    return;
  }

  lpData.setString(textToCopy);


  GlobalUnlock(hGlobal);

  if (OpenClipboard(NULL) != 0) {
    EmptyClipboard();
    SetClipboardData(CF_UNICODETEXT, hGlobal.address);
    CloseClipboard();
  }

  GlobalFree(hGlobal);
}

class PasteboardWindows {
  void writeString() {}
}
