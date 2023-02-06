
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'hydra_helper_platform_interface.dart';

class HydraHelper {
  Future<String?> getPlatformVersion() {
    return HydraHelperPlatform.instance.getPlatformVersion();
  }

  Future<Uint8List?>decryptMasterKey(Uint8List key) {
    return HydraHelperPlatform.instance.decryptMasterKey(key);
  }
}
