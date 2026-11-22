// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'device_architecture_detector.dart';

Future<AndroidArchitecture> detectArchitectureImpl() async {
  try {
    final nav = html.window.navigator;
    final userAgent = nav.userAgent.toLowerCase();
    final platform = (nav.platform ?? '').toLowerCase();
    final combined = '$userAgent $platform';

    // Signatures de processeurs 64 bits (ARM64-v8a / AArch64)
    if (combined.contains('aarch64') ||
        combined.contains('arm64') ||
        combined.contains('armv8') ||
        combined.contains('x86_64') ||
        combined.contains('win64') ||
        combined.contains('x64')) {
      return AndroidArchitecture.arm64;
    }

    // Signatures de processeurs 32 bits (ARMv7 / armeabi)
    if (combined.contains('armv7') ||
        combined.contains('armv7l') ||
        combined.contains('armeabi') ||
        combined.contains('i686') ||
        (combined.contains('arm') && !combined.contains('64'))) {
      return AndroidArchitecture.arm32;
    }

    return AndroidArchitecture.unknown;
  } catch (_) {
    return AndroidArchitecture.unknown;
  }
}
