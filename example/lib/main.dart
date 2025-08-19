import 'package:flutter/material.dart';

import 'charts/heatmap_chart_example.dart';
import 'charts/line_chart_example.dart';
import 'charts/bar_chart_example.dart';
import 'charts/pie_chart_example.dart';
import 'charts/radial_tree.dart';
import 'charts/scatter_chart_example.dart';
import 'charts/radar_chart_example.dart';
import 'charts/gauge_chart_example.dart';
import 'charts/candlestick_chart_example.dart';
import 'charts/funnel_chart_example.dart';
import 'charts/pictorial_bar_chart_example.dart';
import 'charts/sunburst_example.dart';
import 'charts/tree_chart.dart';

void main() => runApp(const EChartsDemoApp());

class EChartsDemoApp extends StatelessWidget {
  const EChartsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECharts Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('ECharts Flutter Demo')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                lineChartExample,
                barChartExample,
                pieChartExample,
                radialTreeExample,
                scatterChartExample,
                radarChartExample,
                gaugeChartExample,
                candlestickChartExample,
                funnelChartExample,
                pictorialBarChartExample,
                heatmapChartExample,
                sunburstChartExample,
                treeChartExample,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
