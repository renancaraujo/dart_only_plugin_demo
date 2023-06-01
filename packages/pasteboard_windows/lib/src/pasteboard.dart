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
      GlobalFree(hGlobal);
      return false;
    }

    lpData.setString(string);

    GlobalUnlock(hGlobal);

    if (OpenClipboard(NULL) != 0) {
      SetClipboardData(format.value, hGlobal.address);
      CloseClipboard();
    }

    GlobalFree(hGlobal);

    return true;
  }

  String? readStringForFormat(Format format) {
    String? result;
    if (OpenClipboard(NULL) != 0) {
      if (IsClipboardFormatAvailable(format.value) != 0) {
        final hData = GetClipboardData(format.value);
        if (hData != NULL) {
          final lpData = GlobalLock(Pointer.fromAddress(hData));
          if (lpData != nullptr) {
            final text = lpData.cast<Utf16>().toDartString();
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

  @override
  bool writeHtml(String htmlBody) {
    try {
      return writeStringForFormat(
        _createHtmlContent('<meta charset="utf-8">$htmlBody'),
        Format.html,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  void clearContents() {
    if (OpenClipboard(NULL) != 0) {
      EmptyClipboard();
      CloseClipboard();
    }
  }
}

/// Wraps the content in the standard HTML clipboard format.
///
/// https://docs.microsoft.com/en-us/windows/win32/dataxchg/html-clipboard-format
///
/// Copied from https://github.com/rows/ditto/blob/main/packages/ditto_windows/lib/ditto_windows.dart
String _createHtmlContent(String fragment) {
  const htmlTag = '<html>';

  const startFragmentTag = '<!--StartFragment-->';
  const endFragmentTag = '<!--EndFragment-->';

  const header = 'Version:0.9\r\n'
      'StartHTML:00000000\r\n'
      'EndHTML:00000000\r\n'
      'StartFragment:00000000\r\n'
      'EndFragment:00000000\r\n'
      '$htmlTag\r\n'
      '<body>\r\n'
      '$startFragmentTag';

  const footer = '$endFragmentTag\r\n'
      '</body>\r\n'
      '</html>\r';

  var content = header + fragment + footer;
  final htmlStartIndex = content.indexOf(htmlTag);
  content = content.replaceFirst(
    'StartHTML:00000000',
    'StartHTML:${htmlStartIndex.toString().padLeft(8, '0')}',
  );

  content = content.replaceFirst(
    'EndHTML:00000000',
    'EndHTML:${(content.length - 1).toString().padLeft(8, '0')}',
  );

  final fragmentStartIndex =
      content.indexOf(startFragmentTag) + startFragmentTag.length;
  content = content.replaceFirst(
    'StartFragment:00000000',
    'StartFragment:${fragmentStartIndex.toString().padLeft(8, '0')}',
  );

  final fragmentEndIndex = content.indexOf(endFragmentTag);
  return content.replaceFirst(
    'EndFragment:00000000',
    'EndFragment:${fragmentEndIndex.toString().padLeft(8, '0')}',
  );
}
