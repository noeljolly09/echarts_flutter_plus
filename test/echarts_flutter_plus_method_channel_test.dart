import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelEchartsFlutterPlus platform = MethodChannelEchartsFlutterPlus();
  const MethodChannel channel = MethodChannel('echarts_flutter_plus');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
