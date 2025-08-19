import 'package:flutter_test/flutter_test.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus_platform_interface.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEchartsFlutterPlusPlatform
    with MockPlatformInterfaceMixin
    implements EchartsFlutterPlusPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EchartsFlutterPlusPlatform initialPlatform =
      EchartsFlutterPlusPlatform.instance;

  test('$MethodChannelEchartsFlutterPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEchartsFlutterPlus>());
  });

  test('getPlatformVersion', () async {
    EchartsFlutterPlus echartsFlutterPlusPlugin = EchartsFlutterPlus();
    MockEchartsFlutterPlusPlatform fakePlatform =
        MockEchartsFlutterPlusPlatform();
    EchartsFlutterPlusPlatform.instance = fakePlatform;

    expect(await echartsFlutterPlusPlugin.getPlatformVersion(), '42');
  });
}
