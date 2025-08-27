# echarts_flutter_plus

A Flutter plugin to seamlessly embed and display powerful Apache ECharts charts on Flutter Web.

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

- Full integration of Apache ECharts for Flutter Web.
- Supports rendering many chart types: line, bar, pie, sunburst, tree, and more.
- Customize charts fully by passing ECharts option JSON string.
- Supports asynchronous loading of ECharts JavaScript library from CDN.
- Smooth dynamic updates and redraws with reactive option changes.
- Custom error handling via user-provided error widgets.
- Supports dark and light themes via a convenient Dart enum.
- Rich event callbacks: subscribe to any ECharts event (click, zoom, mouseover).
- Lightweight, easy-to-use Flutter widget.

---

## Widget Props

| Parameter            | Type                                  | Description                                           | Default |
|----------------------|-------------------------------------|-------------------------------------------------------|---------|
| `option`             | `String` (required)                 | JSON string of the ECharts option to render the chart | —       |
| `width`              | `double`                           | Chart width in pixels                                  | 400     |
| `height`             | `double`                           | Chart height in pixels                                 | 300     |
| `theme`              | `String?`                         | Optional ECharts theme name                            | null    |
| `enableLogger`       | `bool`                            | Print debug logs in browser console                    | false   |
| `errorBuilder`       | `Widget Function(BuildContext, Object, StackTrace?)?` | Widget builder for displaying errors                  | null    |
| `loadTimeoutSeconds` | `int`                             | Seconds before ECharts load timeout triggers an error | 12      |
| `reload`             | `int`                             | Increment to force chart reload                        | 0       |
| `containerAttributes`| `Map<String, String>?`            | Extra HTML container attributes                        | null    |
| `initOptions`        | `JSAny?`                          | Extra ECharts JS initialization options (advanced)    | null    |
| `onEvents`        | `Map<String, void Function(dynamic)>?`                          | Map of ECharts event names to Dart event handler callbacks    | null    |

---


## Parameters and Settings
A string containing the [JSON configuration](https://echarts.apache.org/en/option.html#title) for the chart, based on the Apache ECharts documentation.

---

## Getting Started

### Installation

Add this to your `pubspec.yaml` dependencies section:

```dart
dependencies:
  echarts_flutter_plus: ^0.0.4

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
            'click': (params) {
              debugPrint('Clicked: $params');
            },
            'mouseover': (params) {
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
    'click': (params) => debugPrint('Clicked: $params'),
    'datazoom': (params) => debugPrint('Zoomed: $params'),
  },
);

```

---



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


