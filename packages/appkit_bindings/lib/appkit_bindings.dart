import 'dart:ffi';

import 'package:appkit_bindings/src/appkit_bindings.dart';
export 'package:appkit_bindings/src/appkit_bindings.dart';

const _relativeAppKitDylibPath = 'libswiftAppKit.dylib';

AppKit loadAppKit() {
  return AppKit(DynamicLibrary.open(_relativeAppKitDylibPath));
}
