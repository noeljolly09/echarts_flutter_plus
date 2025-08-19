import '../widget/chart_demo_card.dart';

const barChartOption = '''
{
  "xAxis": {"type": "category", "data": ["A", "B", "C", "D", "E", "F"]},
  "yAxis": {"type": "value"},
  "series": [{
    "data": [120, 200, 150, 80, 70, 110],
    "type": "bar"
  }]
}
''';

final barChartExample = ChartDemoCard(
  title: "Bar Chart",
  optionJson: barChartOption,
  width: 600,
  height: 400,
);
