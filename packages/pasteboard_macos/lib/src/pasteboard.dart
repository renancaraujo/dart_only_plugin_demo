import 'package:appkit_bindings/appkit_bindings.dart';
import 'package:pasteboard_interface/pasteboard_interface.dart';
import 'package:pasteboard_macos/src/types.dart';

class PasteboardMacos implements PasteboardInterface {
  PasteboardMacos(this.nsPasteboard);

  static final AppKit appKitLib = loadAppKit();

  static final PasteboardMacos general = PasteboardMacos(
    (() {
      return NSPasteboard.getGeneralPasteboard(appKitLib)!;
    })(),
  );

  final NSPasteboard nsPasteboard;

  void clearContents() {
    nsPasteboard.clearContents();
  }

  bool writeStringForType(String string, PasteboardType type) {
    final str = NSString(appKitLib, string);
    clearContents();
    return nsPasteboard.setString_forType_(str, type.getNSString(appKitLib));
  }

  String? readStringForType(PasteboardType type) {
    final str = nsPasteboard.stringForType_(type.getNSString(appKitLib));

    return str.toString();
  }

  @override
  bool writeString(String string) {
    try {
      return writeStringForType(string, PasteboardType.string);
    } catch (e) {
      return false;
    }
  }

  @override
  String? readString() {
    return readStringForType(PasteboardType.string);
  }

  @override
  bool writeHtml(String htmlBody) {
    try {
      return writeStringForType(htmlBody, PasteboardType.html);
    } catch (e) {
      return false;
    }
  }
}
