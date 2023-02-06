import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hydra_helper_method_channel.dart';

abstract class HydraHelperPlatform extends PlatformInterface {
  /// Constructs a HydraHelperPlatform.
  HydraHelperPlatform() : super(token: _token);

  static final Object _token = Object();

  static HydraHelperPlatform _instance = MethodChannelHydraHelper();

  /// The default instance of [HydraHelperPlatform] to use.
  ///
  /// Defaults to [MethodChannelHydraHelper].
  static HydraHelperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HydraHelperPlatform] when
  /// they register themselves.
  static set instance(HydraHelperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Uint8List?> decryptMasterKey(Uint8List key) {
    throw UnimplementedError('decryptMasterKey() has not been implemented.');
  }
}
