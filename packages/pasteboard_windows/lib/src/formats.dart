import 'package:win32/win32.dart';

enum Formats {
  text(CF_TEXT),
  unicodeText(CF_UNICODETEXT),
  bitmap(CF_BITMAP),
  metafilePict(CF_METAFILEPICT),
  syLK(CF_SYLK),
  dIF(CF_DIF),
  tIFF(CF_TIFF),
  dIB(CF_DIB),
  palette(CF_PALETTE),
  penData(CF_PENDATA),
  rIFF(CF_RIFF),
  wave(CF_WAVE),;

  const Formats(this.value);

  final int value;
}
