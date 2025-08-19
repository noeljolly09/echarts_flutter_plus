import '../widget/chart_demo_card.dart';

const scatterChartOption = '''
{
  "xAxis": {},
  "yAxis": {},
  "series": [{
    "symbolSize": 20,
    "data": [
      [10, 8], [15, 32], [20, 20], [30, 18], [40, 12]
    ],
    "type": "scatter"
  }]
}
''';

final scatterChartExample = ChartDemoCard(
  title: "Scatter Chart",
  optionJson: scatterChartOption,
  width: 600,
  height: 400,
);
