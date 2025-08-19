import '../widget/chart_demo_card.dart';

const lineChartOption = '''
{
  "xAxis": {"type": "category", "data": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]},
  "yAxis": {"type": "value"},
  "series": [{
    "data": [820, 932, 901, 934, 1290, 1330, 1320],
    "type": "line"
  }]
}
''';

final lineChartExample = ChartDemoCard(
  title: "Line Chart",
  optionJson: lineChartOption,
  width: 600,
  height: 400,
);
