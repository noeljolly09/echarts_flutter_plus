# echarts_flutter_plus

A Flutter web plugin to fully integrate Apache ECharts in Flutter Web apps, enabling rich visualizations with dynamic configuration and event handling.

---

<p align="center">
  <a href="https://pub.dev/packages/echarts_flutter_plus"><img src="https://img.shields.io/pub/v/echarts_flutter_plus.svg" alt="Pub Version" /></a>
  <a href="https://github.com/noeljolly09/echarts_flutter_plus/stargazers"><img src="https://img.shields.io/github/stars/noeljolly09/echarts_flutter_plus.svg" alt="GitHub stars" /></a>
  <a href="https://flutter.dev/docs/development/data-and-backend/state-mgmt/options#bloc--rx"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
  <a href="https://pub.dev/publisher/noeljolly09">
    <img src="https://img.shields.io/pub/likes/echarts_flutter_plus.svg" alt="Likes on pub.dev" />
  </a>
</p>

---

## Features

- Full integration of Apache ECharts JavaScript library for Flutter Web.
- Supports a wide variety of chart types: line, bar, pie, sunburst, tree, scatter, and more.
- Allows configuration with complete ECharts option JSON or raw JS object string.
- Safe default mode parsing pure JSON options; optional raw JS parsing for advanced features.
- Asynchronously loads the ECharts JS library from CDN.
- Supports dynamic updates and smooth redrawing on option changes and reloading.
- Custom error handling with user-provided error widgets.
- Supports dark and light themes via ChartThemeMode.
- Rich event subscription mechanism to receive callbacks on any ECharts event.
- Lightweight, easy-to-use Flutter widget for embedding charts.

---

## Widget Props

| Parameter            | Type                                  | Description                                           | Default |
|----------------------|-------------------------------------|-------------------------------------------------------|---------|
| `option`             | `String` (required)                 | The ECharts option string. When rawOption is false, must be valid JSON. | —       |
| `rawOption`              | `bool`                           | If true, option is parsed as a raw JavaScript object literal (unsafe).                                  | false     |
| `width`              | `double`                           | Chart width in pixels                                  | 400     |
| `height`             | `double`                           | Chart height in pixels                                 | 300     |
| `theme`              | `String?`                         | Chart theme mode (e.g., light or dark). Defaults to light if null.                            | null    |
| `enableLogger`       | `bool`                            | Print debug logs in browser console                    | false   |
| `errorBuilder`       | `Widget Function(BuildContext, Object, StackTrace?)?` | Widget builder for displaying errors                  | null    |
| `loadTimeoutSeconds` | `int`                             | Seconds before ECharts load timeout triggers an error | 12      |
| `reload`             | `int`                             | Increment to force chart reload                        | 0       |
| `initOptions`        | `JSAny?`                          | Extra ECharts JS initialization options (advanced)    | null    |
| `onEvents`        | `Map<EChartsEvent, void Function(dynamic)>?`                          | Map of ECharts event names to Dart event handler callbacks    | null    |

---


## Parameters and Settings
A string containing the [JSON configuration](https://echarts.apache.org/en/option.html#title) for the chart, based on the Apache ECharts documentation.

---

## Getting Started

### Installation

Add this to your `pubspec.yaml` dependencies section:

```dart
dependencies:
  echarts_flutter_plus: ^0.0.7

```

Now in your Dart code, you can use:

```dart
import 'package:echarts_flutter_plus/echarts_flutter_plus.dart';  
```

Details see [pub.dev](https://pub.dev/packages/echarts_flutter_plus#-installing-tab-).

--- 

### Usage

Import the package in your Dart code:


```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus.dart';

final option = {
  'xAxis': {
    'type': 'category',
    'data': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
  },
  'yAxis': {
    'type': 'value',
  },
  'series': [
    {
      'type': 'line',
      'data': [820, 932, 901, 934],
    },
  ],
};

class SimpleChartDemo extends StatelessWidget {
  const SimpleChartDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ECharts Demo')),
      body: Center(
        child: EChartsWebView(
          option: jsonEncode(option),
          width: 400,
          height: 300,
          theme: ChartThemeMode.dark,
          enableLogger: true,
          onEvents: {
            EChartsEvent.click: (params) {
              debugPrint('Clicked: $params');
            },
            EChartsEvent.mouseover: (params) {
              debugPrint('Mouse over: $params');
            },
          },
        ),
      ),
    );
  }
}
```

---


### Raw JavaScript Option Usage (Advanced)

Enable rawOption to allow the entire option string to include JavaScript code such as formatter functions:

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus.dart';

final rawOption = '''
{
  tooltip: {
    formatter: function(params) {
      return params.name + ': ' + params.value;
    }
  },
  xAxis: {
    type: 'category',
    data: ['Mon', 'Tue', 'Wed'],
  },
  yAxis: { type: 'value' },
  series: [{
    type: 'line',
    data: [150, 230, 210]
  }]
}
''';

class SimpleChartDemo extends StatelessWidget {
  const SimpleChartDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ECharts Demo')),
      body: Center(
        child: EChartsWebView(
          option: rawOption,
          width: 400,
          height: 300,
          rawOption: true,
          theme: ChartThemeMode.dark,
          enableLogger: true,
          onEvents: {
            EChartsEvent.click: (params) {
              debugPrint('Clicked: $params');
            },
            EChartsEvent.mouseover: (params) {
              debugPrint('Mouse over: $params');
            },
          },
        ),
      ),
    );
  }
}
```

---

## Event Handling

You can listen to any ECharts event by passing a map of event names to callbacks in `onEvents`. The callbacks receive the raw event data.

```dart
EChartsWebView(
  option: jsonEncode(option),
  onEvents: {
    EChartsEvent.click: (params) => debugPrint('Clicked: $params'),
    EChartsEvent.datazoom: (params) => debugPrint('Zoomed: $params'),
  },
);

```
---

## Error Handling

You can customize how errors are displayed by providing the `errorBuilder` property:

```dart
EChartsWebView(
    option: jsonEncode(yourOption),
    errorBuilder: (context, error, stackTrace) {
        return Center(child: Text('Error loading chart: $error'));
    },
);

```

---

## Development & Contribution

Contributions, bug reports, and feature requests are welcome!  
Please open issues or pull requests on [GitHub repository](https://github.com/noeljolly09/echarts_flutter_plus).

---

## Acknowledgments

This plugin loads [Apache ECharts](https://echarts.apache.org/en/index.html), which is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

If you use this plugin, you are also subject to the Apache 2.0 license for the ECharts library itself.

---

## License

This plugin is licensed under the MIT License.


