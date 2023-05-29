import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final _htmlFormat = RegisterClipboardFormat('HTML Format'.toNativeUtf16());

final class Format {

  Format._(this.value);
  static final text = Format._(CF_UNICODETEXT);
  static final html = Format._(_htmlFormat);

  final int value;
}
