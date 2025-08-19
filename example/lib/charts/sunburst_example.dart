import 'dart:convert';

import '../utils/hierarchy_data.dart';
import '../widget/chart_demo_card.dart';

final Map<String, dynamic> sunburstOption = {
  'tooltip': {'trigger': 'item', 'triggerOn': 'mousemove'},
  'series': [
    {
      'type': 'sunburst',
      'data': [data],
      'radius': [0, '90%'],
      'label': {'rotate': 'radial'},
      'emphasis': {'focus': 'ancestor'},
    },
  ],
};

final sunburstChartExample = ChartDemoCard(
  title: "Sunburst Chart",
  optionJson: jsonEncode(sunburstOption),
  width: 500,
  height: 500,
);
