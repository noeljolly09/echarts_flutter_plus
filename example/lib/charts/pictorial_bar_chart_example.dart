import '../widget/chart_demo_card.dart';

const pictorialBarOption = '''
{
  "xAxis": {"type": "category", "data": ["X", "Y", "Z"]},
  "yAxis": {"type": "value"},
  "series": [{
    "type": "pictorialBar",
    "symbol": "rect",
    "symbolRepeat": true,
    "symbolSize": [30, 6],
    "data": [60, 120, 180]
  }]
}
''';

final pictorialBarChartExample = ChartDemoCard(
  title: "Pictorial Bar Chart",
  optionJson: pictorialBarOption,
  width: 600,
  height: 400,
);
