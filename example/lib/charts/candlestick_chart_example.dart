import '../widget/chart_demo_card.dart';

const candlestickChartOption = '''
{
  "xAxis": {"data": ["2023-01-01", "2023-01-02", "2023-01-03", "2023-01-04"]},
  "yAxis": {},
  "series": [{
    "type": "candlestick",
    "data": [
      [2320.26, 2320.26, 2287.3, 2362.94],
      [2300, 2291.3, 2288.26, 2308.38],
      [2295.35, 2346.5, 2295.35, 2346.92],
      [2347.22, 2358.98, 2337.35, 2363.8]
    ]
  }]
}
''';

final candlestickChartExample = ChartDemoCard(
  title: "Candlestick Chart",
  optionJson: candlestickChartOption,
  width: 560,
  height: 320,
);
