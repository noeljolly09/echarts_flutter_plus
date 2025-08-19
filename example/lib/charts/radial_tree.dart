import 'dart:convert';

import '../utils/hierarchy_data.dart';
import '../widget/chart_demo_card.dart';

final Map<String, dynamic> treeOption = {
  'tooltip': {'trigger': 'item', 'triggerOn': 'mousemove'},
  'series': [
    {
      'type': 'tree',
      'data': [data],
      'top': '18%',
      'bottom': '14%',
      'layout': 'radial',
      'symbol': 'emptyCircle',
      'symbolSize': 7,
      'initialTreeDepth': 3,
      'animationDurationUpdate': 750,
      'emphasis': {'focus': 'descendant'},
    },
  ],
};

final radialTreeExample = ChartDemoCard(
  title: "Radial Tree Chart",
  optionJson: jsonEncode(treeOption),
  width: 1000,
  height: 1000,
);
