import '../widget/chart_demo_card.dart';

const heatmapChartOption = '''
{
  "xAxis": {"type": "category", "data": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]},
  "yAxis": {"type": "category", "data": ["Morning", "Afternoon", "Evening"]},
  "visualMap": {"min": 0, "max": 10, "calculable": true, "orient": "horizontal", "left": "center", "bottom": "15%"},
  "series": [{
    "name": "Punch Card",
    "type": "heatmap",
    "data": [
      [0,0,5],[0,1,1],[0,2,0],
      [1,0,7],[1,1,3],[1,2,1],
      [2,0,1],[2,1,0],[2,2,1],
      [3,0,2],[3,1,1],[3,2,9],
      [4,0,0],[4,1,1],[4,2,4],
      [5,0,1],[5,1,2],[5,2,4],
      [6,0,3],[6,1,2],[6,2,7]
    ],
    "label": {"show": true}
  }]
}
''';

final heatmapChartExample = ChartDemoCard(
  title: "Heatmap Chart",
  optionJson: heatmapChartOption,
  width: 600,
  height: 350,
);
