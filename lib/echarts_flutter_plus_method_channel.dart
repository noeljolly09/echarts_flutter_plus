import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'echarts_flutter_plus_platform_interface.dart';

/// An implementation of [EchartsFlutterPlusPlatform] that uses method channels.
class MethodChannelEchartsFlutterPlus extends EchartsFlutterPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('echarts_flutter_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
