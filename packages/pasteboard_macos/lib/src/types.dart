import 'package:appkit_bindings/appkit_bindings.dart';

enum PasteboardType {
  string('public.utf8-plain-text'),
  rtf('public.rtf'),
  rtfd('com.apple.flat-rtfd'),
  pdf('com.adobe.pdf'),
  html('public.html'),
  tabularText('public.utf8-tab-separated-values-text'),
  png('public.png'),
  tiff('public.tiff'),
  fileURL('public.file-url'),
  color('com.apple.cocoa.pasteboard.color'),
  sound('com.apple.cocoa.pasteboard.sound'),
  url('public.url'),
  ruler('com.apple.cocoa.pasteboard.paragraph-formatting');

  const PasteboardType(this.value);

  final String value;

  NSString getNSString(AppKit lib) {
    return NSString(lib, value);
  }
}
