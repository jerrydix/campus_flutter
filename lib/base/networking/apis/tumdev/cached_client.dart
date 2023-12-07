import 'dart:async';
import 'dart:io';

import 'package:campus_flutter/base/networking/apis/tumdev/cache_interceptor.dart';
import 'package:campus_flutter/base/networking/apis/tumdev/campus_backend.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CachedCampusClient extends CampusClient {
  static Future<CachedCampusClient> createWebCache() async {
    return CachedCampusClient._webCache(await _callOptions());
  }

  static Future<CachedCampusClient> createMobileCache(
    Directory directory,
  ) async {
    await Hive.openBox('grpc_cache', path: directory.path);
    return CachedCampusClient._mobileCache(directory, await _callOptions());
  }

  CachedCampusClient._webCache(CallOptions callOptions)
      : super(
          _channel(),
          options: callOptions,
          interceptors: [CacheInterceptor.webCache()],
        );

  CachedCampusClient._mobileCache(Directory directory, CallOptions callOptions)
      : super(
          _channel(),
          options: callOptions,
          interceptors: [CacheInterceptor.mobileCache(directory)],
        );

  static Future<CallOptions> _callOptions() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String osVersion = "unknown";
    String deviceId = "unknown";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      osVersion = "web";
      deviceId = webBrowserInfo.userAgent ?? "unknown";
    } else {
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        osVersion = "${iosInfo.systemName} ${iosInfo.systemVersion}";
        deviceId = iosInfo.identifierForVendor ?? "unknown";
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        osVersion = androidInfo.version.toString();
        deviceId = androidInfo.serialNumber;
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
        osVersion = macInfo.osRelease;
        deviceId = macInfo.model;
      }
    }
    return CallOptions(
      metadata: {
        "x-app-version": packageInfo.packageName,
        "x-app-build": packageInfo.version,
        "x-device-id": deviceId,
        "x-os-version": osVersion,
      },
      timeout: const Duration(seconds: 10),
    );
  }

  static GrpcOrGrpcWebClientChannel _channel() {
    return GrpcOrGrpcWebClientChannel.toSeparateEndpoints(
      grpcHost: "api.tum.app",
      grpcPort: 443,
      grpcTransportSecure: true,
      grpcWebHost: "api-grpc.tum.app",
      grpcWebPort: 443,
      grpcWebTransportSecure: true,
    );
  }
}
