
import 'echarts_flutter_plus_platform_interface.dart';

class EchartsFlutterPlus {
  Future<String?> getPlatformVersion() {
    return EchartsFlutterPlusPlatform.instance.getPlatformVersion();
  }
}
