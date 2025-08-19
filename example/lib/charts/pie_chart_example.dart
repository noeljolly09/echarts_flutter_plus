import '../widget/chart_demo_card.dart';

const pieChartOption = '''
{
  "series": [{
    "type": "pie",
    "radius": "60%",
    "data": [
      {"value": 1048, "name": "Search Engine"},
      {"value": 735, "name": "Direct"},
      {"value": 580, "name": "Email"},
      {"value": 484, "name": "Union Ads"},
      {"value": 300, "name": "Video Ads"}
    ]
  }]
}
''';

final pieChartExample = ChartDemoCard(
  title: "Pie Chart",
  optionJson: pieChartOption,
  width: 360,
  height: 360,
);
