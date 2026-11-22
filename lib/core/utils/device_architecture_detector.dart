import 'device_architecture_detector_stub.dart'
    if (dart.library.html) 'device_architecture_detector_web.dart';

/// Architecture du processeur du smartphone Android
enum AndroidArchitecture {
  /// Processeurs 64 bits (ARM64-v8a / aarch64) - ~95% des téléphones récents (Android 8+)
  arm64,

  /// Processeurs 32 bits (armeabi-v7a / armv7) - Téléphones d'entrée de gamme ou anciens modèles
  arm32,

  /// Non détecté ou environnement ne permettant pas la détection
  unknown,
}

/// Service de détection de l'architecture du processeur du téléphone
class DeviceArchitectureDetector {
  static Future<AndroidArchitecture> detect() async {
    return detectArchitectureImpl();
  }
}
