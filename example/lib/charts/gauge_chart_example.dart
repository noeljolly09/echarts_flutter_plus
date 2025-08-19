import '../widget/chart_demo_card.dart';

const gaugeChartOption = '''
{
  "series": [{
    "type": "gauge",
    "progress": {"show": true},
    "detail": {"valueAnimation": true, "formatter": "{value}%"},
    "data": [{"value": 70, "name": "Completion"}]
  }]
}
''';

final gaugeChartExample = ChartDemoCard(
  title: "Gauge Chart",
  optionJson: gaugeChartOption,
  width: 340,
  height: 340,
);
