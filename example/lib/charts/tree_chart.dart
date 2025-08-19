import 'dart:convert';

import '../utils/hierarchy_data.dart';
import '../widget/chart_demo_card.dart';

final Map<String, dynamic> treeOption = {
  'tooltip': {'trigger': 'item', 'triggerOn': 'mousemove'},
  'series': [
    {
      'type': 'tree',
      'data': [data],
      'top': '1%',
      'left': '7%',
      'bottom': '1%',
      'right': '20%',
      'symbolSize': 7,
      'label': {
        'position': 'left',
        'verticalAlign': 'middle',
        'align': 'right',
        'fontSize': 9,
      },
      'leaves': {
        'label': {
          'position': 'right',
          'verticalAlign': 'middle',
          'align': 'left',
        },
      },
      'emphasis': {'focus': 'descendant'},
      'expandAndCollapse': true,
      'animationDuration': 550,
      'animationDurationUpdate': 750,
    },
  ],
};

final treeChartExample = ChartDemoCard(
  title: "Tree Chart",
  optionJson: jsonEncode(treeOption),
  width: 1000,
  height: 1000,
);
