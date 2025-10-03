import 'package:echarts_flutter_plus_example/widget/chart_demo_card.dart';

final String rawTreeOption = '''
{
  tooltip: {
    trigger: 'item',
  },
  series: [{
    type: 'tree',
    data: [{
      name: 'Root',
      children: [
        { name: 'Child 1' },
        { name: 'Child 2' }
      ]
    }],
    label: {
      formatter: function(params) {
        return '**Node**: ' + params.name;
      },
      position: 'left',
      verticalAlign: 'middle',
      align: 'right',
      fontSize: 12,
    },
    leaves: {
      label: {
        formatter: function(params) {
          return 'Leaf: ' + params.name;
        },
        position: 'right',
        verticalAlign: 'middle',
        align: 'left',
        fontSize: 12,
      }
    },
    expandAndCollapse: true,
    animationDuration: 500,
    animationDurationUpdate: 500
  }]
}
''';

final rawJsOptionTreeExample = ChartDemoCard(
  title: "Raw JS Option Tree Chart",
  optionJson: rawTreeOption,
  rawOption: true,
  width: 1000,
  height: 1000,
);
