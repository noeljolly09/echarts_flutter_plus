import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'echarts_flutter_plus_method_channel.dart';

abstract class EchartsFlutterPlusPlatform extends PlatformInterface {
  /// Constructs a EchartsFlutterPlusPlatform.
  EchartsFlutterPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static EchartsFlutterPlusPlatform _instance =
      MethodChannelEchartsFlutterPlus();

  /// The default instance of [EchartsFlutterPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelEchartsFlutterPlus].
  static EchartsFlutterPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EchartsFlutterPlusPlatform] when
  /// they register themselves.
  static set instance(EchartsFlutterPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
