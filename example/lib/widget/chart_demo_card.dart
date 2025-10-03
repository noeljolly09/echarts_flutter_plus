import 'package:echarts_flutter_plus/echarts_flutter_plus_web.dart';
import 'package:flutter/material.dart';

class ChartDemoCard extends StatelessWidget {
  final String title;
  final String optionJson;
  final double width;
  final double height;
  final bool rawOption;

  const ChartDemoCard({
    super.key,
    required this.title,
    required this.optionJson,
    this.rawOption = false,
    this.width = 480,
    this.height = 340,
  });

  @override
  Widget build(BuildContext context) {
    //
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              width: width,
              height: height,
              child: EChartsWebView(
                option: optionJson,
                rawOption: rawOption,
                width: width,
                height: height,
                enableLogger: true,
                onEvents: {
                  // Subscribe to ECharts events using enum names
                  EChartsEvent.click: (params) {
                    debugPrint('Click event: $params');
                  },
                  EChartsEvent.mouseover: (params) {
                    debugPrint('Mouse hover on chart: $params');
                  },
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
