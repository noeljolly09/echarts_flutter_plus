import '../widget/chart_demo_card.dart';

const funnelChartOption = '''
{
  "series": [{
    "type": "funnel",
    "left": "10%",
    "width": "80%",
    "label": {"show": true, "position": "inside"},
    "data": [
      {"value": 60, "name": "Visit"},
      {"value": 40, "name": "Consult"},
      {"value": 20, "name": "Order"},
      {"value": 80, "name": "Click"},
      {"value": 100, "name": "Show"}
    ]
  }]
}
''';

final funnelChartExample = ChartDemoCard(
  title: "Funnel Chart",
  optionJson: funnelChartOption,
  width: 400,
  height: 320,
);
