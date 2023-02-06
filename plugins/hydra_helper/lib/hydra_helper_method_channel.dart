import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hydra_helper_platform_interface.dart';

/// An implementation of [HydraHelperPlatform] that uses method channels.
class MethodChannelHydraHelper extends HydraHelperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hydra_helper');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Uint8List?> decryptMasterKey(Uint8List key) async {
    String? result = await methodChannel.invokeMethod<String>('decryptMasterKey', {"key": base64Encode(key)});
    if (result == null) {
      return null;
    }
    return base64Decode(result);
  }
}
