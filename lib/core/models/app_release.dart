import 'release_feature.dart';

/// Modèle représentant une version (release) de l'application Ngenou
class AppRelease {
  final String id;
  final String versionName;
  final int versionCode;
  final String title;
  final String notes;
  final String? apkUrl;
  final String? apkUrlArm64;
  final String? apkUrlArm32;
  final String? windowsUrl;
  final bool forceUpdate;
  final bool isPublished;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final List<ReleaseFeature> features;

  const AppRelease({
    required this.id,
    required this.versionName,
    required this.versionCode,
    required this.title,
    required this.notes,
    this.apkUrl,
    this.apkUrlArm64,
    this.apkUrlArm32,
    this.windowsUrl,
    this.forceUpdate = false,
    this.isPublished = false,
    this.publishedAt,
    this.createdAt,
    this.features = const [],
  });

  factory AppRelease.fromJson(
    Map<String, dynamic> json, {
    List<ReleaseFeature> features = const [],
  }) {
    return AppRelease(
      id: json['id'] as String? ?? '',
      versionName: json['version_name'] as String? ?? '',
      versionCode: (json['version_code'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      apkUrl: json['apk_url'] as String?,
      apkUrlArm64: json['apk_url_arm64'] as String?,
      apkUrlArm32: json['apk_url_arm32'] as String?,
      windowsUrl: json['windows_url'] as String?,
      forceUpdate: json['force_update'] as bool? ?? false,
      isPublished: json['is_published'] as bool? ?? false,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      features: features,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final map = <String, dynamic>{
      'version_name': versionName,
      'version_code': versionCode,
      'title': title,
      'notes': notes,
      'apk_url': apkUrl,
      'apk_url_arm64': apkUrlArm64,
      'apk_url_arm32': apkUrlArm32,
      'windows_url': windowsUrl,
      'force_update': forceUpdate,
      'is_published': isPublished,
      'published_at': publishedAt?.toIso8601String(),
    };
    if (includeId && id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }

  String get effectiveArm64Url {
    if (apkUrlArm64 != null && apkUrlArm64!.isNotEmpty) return apkUrlArm64!;
    if (apkUrl != null && apkUrl!.isNotEmpty) {
      if (apkUrl!.contains('.apk')) {
        return apkUrl!.replaceAll('.apk', '-arm64.apk');
      }
      return apkUrl!;
    }
    if (versionName.isNotEmpty) {
      return 'https://github.com/Francko0237/Ngenou_Web/releases/download/v$versionName/ngenou-v$versionName-arm64.apk';
    }
    return 'https://github.com/Francko0237/Ngenou_Web/releases/latest/download/ngenou-arm64.apk';
  }

  String get effectiveArm32Url {
    if (apkUrlArm32 != null && apkUrlArm32!.isNotEmpty) return apkUrlArm32!;
    if (apkUrl != null && apkUrl!.isNotEmpty) {
      if (apkUrl!.contains('.apk')) {
        return apkUrl!.replaceAll('.apk', '-arm32.apk');
      }
      return apkUrl!;
    }
    if (versionName.isNotEmpty) {
      return 'https://github.com/Francko0237/Ngenou_Web/releases/download/v$versionName/ngenou-v$versionName-arm32.apk';
    }
    return 'https://github.com/Francko0237/Ngenou_Web/releases/latest/download/ngenou-arm32.apk';
  }

  AppRelease copyWith({
    String? id,
    String? versionName,
    int? versionCode,
    String? title,
    String? notes,
    String? apkUrl,
    bool? forceUpdate,
    bool? isPublished,
    DateTime? publishedAt,
    DateTime? createdAt,
    List<ReleaseFeature>? features,
  }) {
    return AppRelease(
      id: id ?? this.id,
      versionName: versionName ?? this.versionName,
      versionCode: versionCode ?? this.versionCode,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      apkUrl: apkUrl ?? this.apkUrl,
      forceUpdate: forceUpdate ?? this.forceUpdate,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      features: features ?? this.features,
    );
  }
}
