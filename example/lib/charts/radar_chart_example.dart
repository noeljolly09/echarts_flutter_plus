import '../widget/chart_demo_card.dart';

const radarChartOption = '''
{
  "radar": {
    "indicator": [
      {"name": "A", "max": 6500},
      {"name": "B", "max": 16000},
      {"name": "C", "max": 30000},
      {"name": "D", "max": 38000},
      {"name": "E", "max": 52000},
      {"name": "F", "max": 25000}
    ]
  },
  "series": [{
    "name": "Budget",
    "type": "radar",
    "data": [
      {"value": [4300, 10000, 28000, 35000, 50000, 19000], "name": "Allocated"},
      {"value": [5000, 14000, 28000, 31000, 42000, 21000], "name": "Actual"}
    ]
  }]
}
''';

final radarChartExample = ChartDemoCard(
  title: "Radar Chart",
  optionJson: radarChartOption,
  width: 600,
  height: 400,
);
