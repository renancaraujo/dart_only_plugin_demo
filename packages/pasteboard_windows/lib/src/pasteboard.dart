import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

typedef OpenClipboardC = Int32 Function(IntPtr hWndNewOwner);
typedef OpenClipboardDart = int Function(int hWndNewOwner);

typedef CloseClipboardC = Int32 Function();
typedef CloseClipboardDart = int Function();

typedef IsClipboardFormatAvailableC = Int32 Function(Uint32 format);
typedef IsClipboardFormatAvailableDart = int Function(int format);

typedef GetClipboardDataC = IntPtr Function(Uint32 uFormat);
typedef GetClipboardDataDart = int Function(int uFormat);

void main() {
  final user32 = DynamicLibrary.open('user32.dll');

  final OpenClipboard = user32
      .lookupFunction<OpenClipboardC, OpenClipboardDart>('OpenClipboard');
  final CloseClipboard = user32
      .lookupFunction<CloseClipboardC, CloseClipboardDart>('CloseClipboard');
  final IsClipboardFormatAvailable = user32.lookupFunction<
      IsClipboardFormatAvailableC,
      IsClipboardFormatAvailableDart>('IsClipboardFormatAvailable');
  final GetClipboardData = user32
      .lookupFunction<GetClipboardDataC, GetClipboardDataDart>('GetClipboardData');

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
