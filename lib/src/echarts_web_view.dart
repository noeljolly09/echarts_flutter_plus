import 'dart:async';
import 'dart:convert';
import 'package:echarts_flutter_plus/echarts_flutter_plus_platform_interface.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus_web.dart';
import 'package:flutter/widgets.dart';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;

class EchartsFlutterPlusWeb extends EchartsFlutterPlusPlatform {
  static void registerWith(dynamic registrar) {
    EchartsFlutterPlusPlatform.instance = EchartsFlutterPlusWeb();
  }

  @override
  Future<String?> getPlatformVersion() async {
    return web.window.navigator.userAgent;
  }
}

@JS('echarts')
external JSObject? get _echarts;

@JS('echarts.init')
external JSObject _echartsInit(web.Element el, [String? theme, JSAny? opts]);

@JS('eval')
external JSAny? _evaluateJS(JSString code);

@JS('JSON.parse')
external JSObject _jsParseJson(String json);

@JS('window.onEChartsEvent')
external set _onEChartsEvent(JSFunction f);

extension EChartsInterop on JSObject {
  external void setOption(JSAny option, [bool? notMerge]);
  external void dispose();
  external void resize();
  external void on(String eventName, JSFunction callback);
  external void off(String eventName, [JSFunction? callback]);
}

class EChartsWebView extends StatefulWidget {
  /// The ECharts chart configuration option, represented as a string.
  ///
  /// This controls the entire chart setup:
  /// - When [rawOption] is `false` (default), this string must be valid JSON.
  ///   Functions such as formatters are NOT allowed and should be represented
  ///   as strings or static values.
  ///
  ///   Example:
  ///   ```
  ///   EChartsWebView(
  ///     option: '''
  ///     {
  ///       "tooltip": {
  ///         "formatter": "{b}: {c}"
  ///       },
  ///       "xAxis": {
  ///         "type": "category",
  ///         "data": ["A", "B", "C"]
  ///       },
  ///       "yAxis": {},
  ///       "series": [{
  ///         "type": "bar",
  ///         "data":[5]
  ///       }]
  ///     }
  ///     ''',
  ///   )
  ///   ```
  ///
  /// - When [rawOption] is `true`, the entire string is treated as a JavaScript
  ///   object literal and can include inline JS functions (e.g., formatters).
  ///   Be cautious and only use trusted input as this enables code execution.
  ///
  ///   Example:
  ///   ```
  ///   EChartsWebView(
  ///     rawOption: true,
  ///     option: '''
  ///     {
  ///       tooltip: {
  ///         formatter: function(params) {
  ///           return params.name + ': ' + params.value;
  ///         }
  ///       },
  ///       xAxis: {
  ///         type: 'category',
  ///         data: ['A', 'B', 'C']
  ///       },
  ///       yAxis: {},
  ///       series: [{
  ///         type: 'bar',
  ///         data:[5]
  ///       }]
  ///     }
  ///     ''',
  ///   )
  ///   ```
  final String option;

  /// When `true`, [option] is treated as a raw JS object literal string which
  /// can include JavaScript functions like formatters.
  ///
  /// When `false` (default), [option] must be pure JSON with no functions.
  final bool rawOption;

  /// The width of the chart container in pixels.
  ///
  /// Defaults to 400.
  final double width;

  /// The height of the chart container in pixels.
  ///
  /// Defaults to 300.
  final double height;

  /// The theme mode for the chart appearance.
  ///
  /// If null, defaults to [ChartThemeMode.light].
  final ChartThemeMode? theme;

  /// Enables debug logging output if set to `true`.
  ///
  /// Defaults to `false`.
  final bool enableLogger;

  /// A builder function that returns a widget to display in case of an error.
  ///
  /// It provides the [context], the [error] object, and an optional [stack] trace.
  final Widget Function(BuildContext context, Object error, StackTrace? stack)?
  errorBuilder;

  /// Timeout in seconds to wait for ECharts JS to load before failing.
  ///
  /// Defaults to 12.
  final int loadTimeoutSeconds;

  /// A parameter to force full reload of the chart when changed.
  ///
  /// Use this to trigger a complete recreation of the chart instance.
  final int reload;

  /// Optional ECharts initialization options passed to `echarts.init`.
  ///
  /// Use this to provide additional options such as renderer or devicePixelRatio.
  final JSAny? initOptions;

  /// A map of ECharts events to Dart callback functions.
  ///
  /// Supports events such as `click`, `legendselectchanged`, etc.
  /// Callbacks receive the event parameters as a dynamic object.
  final Map<EChartsEvent, void Function(dynamic params)>? onEvents;

  const EChartsWebView({
    super.key,
    required this.option,
    this.rawOption = false,
    this.width = 400,
    this.height = 300,
    this.theme,
    this.enableLogger = false,
    this.errorBuilder,
    this.loadTimeoutSeconds = 12,
    this.reload = 0,
    this.initOptions,
    this.onEvents,
  });

  @override
  State<EChartsWebView> createState() => _EChartsWebViewState();
}

class _EChartsWebViewState extends State<EChartsWebView> {
  late web.Element _container;
  JSObject? _chart;
  late String _viewType;
  static Future<void>? _echartsLoader;
  static int _instanceCounter = 0;
  Object? _lastError;
  StackTrace? _lastStack;

  final _unsafePatterns = <RegExp>[
    RegExp(r'window', caseSensitive: false),
    RegExp(r'document', caseSensitive: false),
    RegExp(r'eval', caseSensitive: false),
    RegExp(r'new\s+Function', caseSensitive: false),
    RegExp(r'fetch', caseSensitive: false),
    RegExp(r'XMLHttpRequest', caseSensitive: false),
    RegExp(r'WebSocket', caseSensitive: false),
    RegExp(r'postMessage', caseSensitive: false),
    RegExp(r'localStorage', caseSensitive: false),
    RegExp(r'sessionStorage', caseSensitive: false),
    RegExp(r'location', caseSensitive: false),
    RegExp(r'constructor', caseSensitive: false),
    RegExp(r'__proto__', caseSensitive: false),
    RegExp(r'prototype', caseSensitive: false),
    RegExp(r'setTimeout', caseSensitive: false),
    RegExp(r'setInterval', caseSensitive: false),
    RegExp(r'<script\s*>', caseSensitive: false),
    RegExp(r'import\s*\(', caseSensitive: false),
    RegExp(r'require\s*\(', caseSensitive: false),
    RegExp(r'while\s*\(\s*true\s*\)', caseSensitive: false),
    RegExp(r'for\s*\(\s*;;\s*\)', caseSensitive: false),
  ];

  bool _isSafeOptionStr(String option) {
    for (final pattern in _unsafePatterns) {
      if (pattern.hasMatch(option)) {
        if (widget.enableLogger) {
          debugPrint(
            '[EChartsWebView] Blocked unsafe token: ${pattern.pattern}',
          );
        }
        return false;
      }
    }

    // If there are no function tokens, safe to parse as JSON.
    if (!RegExp(r'\bfunction\b|=>').hasMatch(option)) {
      return true;
    }

    // Allowed keys for functions inside raw option
    final allowedKeys = [
      r'formatter',
      r'renderItem',
      r'encode',
      r'label\.formatter',
      r'tooltip\.formatter',
      r'axisLabel\.formatter',
      r'tooltipFormatter',
    ];

    final funcMatches = RegExp(r'\bfunction\b|\=\>\s*{?').allMatches(option);
    for (final match in funcMatches) {
      final idx = match.start;
      // Lookback to find key context before function keyword
      final startIdx = (idx - 120).clamp(0, option.length);
      final snippet = option.substring(startIdx, idx).toLowerCase();

      bool allowed = false;
      for (final key in allowedKeys) {
        if (RegExp(
          r'\b' + key + r'\b',
          caseSensitive: false,
        ).hasMatch(snippet)) {
          allowed = true;
          break;
        }
      }
      if (!allowed) {
        if (widget.enableLogger) {
          debugPrint(
            '[EChartsWebView] Rejected function near position $idx; context: $snippet',
          );
        }
        return false;
      }

      // Check body for suspicious tokens
      final endIdx = (idx + 300).clamp(0, option.length);
      final bodySnippet = option.substring(idx, endIdx).toLowerCase();
      final suspiciousTokens = [
        'fetch(',
        'xmlhttprequest',
        'new function',
        '.apply(',
        '.call(',
        'postmessage',
        'localstorage',
        'sessionstorage',
        'document.',
        'window.',
        'import(',
        'require(',
        'while(true)',
        'for(;;)',
      ];
      for (final token in suspiciousTokens) {
        if (bodySnippet.contains(token)) {
          if (widget.enableLogger) {
            debugPrint(
              '[EChartsWebView] Suspicious token in function body: $token',
            );
          }
          return false;
        }
      }
    }

    return true;
  }

  static Future<void> _loadEcharts({
    bool enableLogger = false,
    int timeout = 12,
  }) {
    if (_echartsLoader != null) return _echartsLoader!;
    final completer = Completer<void>();
    final script = web.document.createElement('script');
    script.setAttribute(
      'src',
      'https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js',
    );
    script.setAttribute('type', 'text/javascript');
    script.setAttribute('async', 'true');
    web.document.body!.append(script);

    Timer? timer;
    int pollCount = 0;
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      pollCount++;
      try {
        if (_echarts != null) {
          if (enableLogger) {
            debugPrint(
              '[EChartsWebView] ECharts loaded after ${pollCount * 100}ms',
            );
          }
          if (!completer.isCompleted) completer.complete();
          timer?.cancel();
        }
      } catch (_) {}
    });

    Future.delayed(Duration(seconds: timeout), () {
      if (!completer.isCompleted) {
        timer?.cancel();
        if (enableLogger) {
          debugPrint(
            '[EChartsWebView] ERROR: ECharts JS did not load in $timeout seconds',
          );
        }
        completer.completeError(TimeoutException('ECharts JS load timeout'));
      }
    });

    _echartsLoader = completer.future;
    return _echartsLoader!;
  }

  void _log(Object? message) {
    if (widget.enableLogger) debugPrint('[EChartsWebView] $message');
  }

  @override
  void initState() {
    super.initState();

    if (widget.rawOption && _looksLikeJson(widget.option)) {
      debugPrint(
        '⚠️ [EChartsWebView]: rawOption=true but option looks like JSON. Use rawOption=false if you don\'t need JS functions.',
      );
    }

    _prepareContainer();
    _viewType = 'echarts-view-${_instanceCounter++}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (id) => _container,
    );
    _initChart();
  }

  void _prepareContainer() {
    _container = web.document.createElement('div');
    _container.setAttribute(
      'style',
      'width: ${widget.width}px; height: ${widget.height}px;',
    );
  }

  bool _looksLikeJson(String s) {
    final trimmed = s.trim();
    if (!(trimmed.startsWith('{') || trimmed.startsWith('['))) return false;
    try {
      jsonDecode(trimmed);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _initChart() async {
    _log('Starting ECharts loader');
    try {
      await _loadEcharts(
        enableLogger: widget.enableLogger,
        timeout: widget.loadTimeoutSeconds,
      );
      if (!_isSafeOptionStr(widget.option)) {
        _log('Unsafe option detected - rejecting rendering');
        setState(() {
          _lastError = Exception('Unsafe option rejected');
          _lastStack = null;
        });
        return;
      }
      _renderChart();
    } catch (error, stack) {
      _log('Error loading ECharts: $error');
      setState(() {
        _lastError = error;
        _lastStack = stack;
      });
    }
  }

  JSAny? _jsParseRawOption(String option) {
    final code = '(function() { return ($option); })()';
    try {
      final result = _evaluateJS(code.toJS);
      _log('Raw option parsed successfully');
      return result;
    } catch (e) {
      _log('Error parsing raw option: $e');
      rethrow;
    }
  }

  void _renderChart() {
    _log('Rendering chart');
    _chart?.dispose();

    if (_echarts == null) {
      _log('ECharts JS not loaded');
      return;
    }

    try {
      final JSAny? optionObj =
          widget.rawOption
              ? _jsParseRawOption(widget.option)
              : _jsParseJson(widget.option);

      if (optionObj == null) throw Exception('Failed to parse option');

      _chart = _echartsInit(
        _container,
        widget.theme?.name ?? ChartThemeMode.light.name,
        widget.initOptions,
      );
      _chart!.setOption(optionObj, true);

      _setupEventCallbacks();

      setState(() {
        _lastError = null;
        _lastStack = null;
      });
    } catch (e, stack) {
      _log('Error rendering chart: $e');
      setState(() {
        _lastError = e;
        _lastStack = stack;
      });
    }
  }

  void _setupEventCallbacks() {
    if (_chart == null) {
      _log('Chart instance null, cannot attach events');
      return;
    }

    if (widget.onEvents == null || widget.onEvents!.isEmpty) {
      _log('No events to subscribe');
      return;
    }

    widget.onEvents!.forEach((eventEnum, dartCallback) {
      final eventName = eventEnum.name;
      JSFunction jsCallback = ((JSAny params) => dartCallback(params)).toJS;
      _chart!.on(eventName, jsCallback);
    });

    _onEChartsEvent =
        ((String event, JSAny params) {
          final eventEnum = EChartsEvent.values.firstWhere(
            (e) => e.name == event,
            orElse: () => EChartsEvent.click,
          );
          if (widget.onEvents != null &&
              widget.onEvents!.containsKey(eventEnum)) {
            widget.onEvents![eventEnum]!(params);
          }
        }).toJS;
  }

  @override
  void didUpdateWidget(covariant EChartsWebView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.reload != widget.reload) {
      _log('Reload requested');
      _prepareContainer();
      _initChart();
      return;
    }

    if (oldWidget.option != widget.option ||
        oldWidget.rawOption != widget.rawOption) {
      if (!_isSafeOptionStr(widget.option)) {
        _log('Unsafe option detected on update - rejecting change');
        setState(() {
          _lastError = Exception('Unsafe option rejected');
          _lastStack = null;
        });
        return;
      }

      try {
        final JSAny? optionObj =
            widget.rawOption
                ? _jsParseRawOption(widget.option)
                : _jsParseJson(widget.option);

        if (optionObj == null) throw Exception('Failed to parse option');

        _chart?.setOption(optionObj, true);

        setState(() {
          _lastError = null;
          _lastStack = null;
        });
      } catch (error, stack) {
        _log('Error updating chart options: $error');
        setState(() {
          _lastError = error;
          _lastStack = stack;
        });
      }
    }

    if (oldWidget.width != widget.width || oldWidget.height != widget.height) {
      _container.setAttribute(
        'style',
        'width: ${widget.width}px; height: ${widget.height}px;',
      );
      _chart?.resize();
    }

    if (oldWidget.theme != widget.theme) {
      _renderChart();
    }
  }

  @override
  void dispose() {
    _chart?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastError != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _lastError!, _lastStack);
      }
      _log('Chart rendering error: $_lastError');
      return const SizedBox.shrink();
    }
    return HtmlElementView(viewType: _viewType);
  }
}
