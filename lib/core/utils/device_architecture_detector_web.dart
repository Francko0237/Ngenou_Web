// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'device_architecture_detector.dart';

Future<AndroidArchitecture> detectArchitectureImpl() async {
  try {
    final nav = html.window.navigator;

    // 1. Détection via UserAgentData (W3C Client Hints API standard, supportée par Chrome/Chromium Android)
    if (js_util.hasProperty(nav, 'userAgentData')) {
      final uaData = js_util.getProperty(nav, 'userAgentData');
      if (uaData != null && js_util.hasProperty(uaData, 'getHighEntropyValues')) {
        try {
          final promise = js_util.callMethod(uaData, 'getHighEntropyValues', [
            ['architecture', 'bitness']
          ]);
          final values = await js_util.promiseToFuture<dynamic>(promise);
          if (values != null) {
            final bitness = js_util.getProperty(values, 'bitness')?.toString();
            final arch = js_util.getProperty(values, 'architecture')?.toString()?.toLowerCase() ?? '';

            if (bitness == '64' || arch == 'arm64' || arch == 'aarch64' || arch == 'x86_64') {
              return AndroidArchitecture.arm64;
            } else if (bitness == '32' || arch == 'arm' || arch == 'armv7' || arch == 'armv7l') {
              return AndroidArchitecture.arm32;
            }
          }
        } catch (_) {
          // Fallback sur le parsing standard
        }
      }
    }

    // 2. Détection par analyse du User-Agent et de la plateforme
    final userAgent = nav.userAgent.toLowerCase();
    final platform = (nav.platform ?? '').toLowerCase();
    final combined = '$userAgent $platform';

    // Signatures directes de processeurs 64 bits
    if (combined.contains('aarch64') ||
        combined.contains('arm64') ||
        combined.contains('armv8') ||
        combined.contains('x86_64') ||
        combined.contains('win64') ||
        combined.contains('x64')) {
      return AndroidArchitecture.arm64;
    }

    // Signatures directes de processeurs 32 bits
    if (combined.contains('armv7') ||
        combined.contains('armv7l') ||
        combined.contains('armeabi') ||
        combined.contains('i686') ||
        (combined.contains('arm') && !combined.contains('64'))) {
      return AndroidArchitecture.arm32;
    }

    // 3. Si non détecté avec certitude
    return AndroidArchitecture.unknown;
  } catch (_) {
    return AndroidArchitecture.unknown;
  }
}
