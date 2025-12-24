import 'dart:async';
import 'dart:convert';
import 'dart:ui_web' as ui_web;
import 'package:echarts_flutter_plus/echarts_flutter_plus_platform_interface.dart';
import 'package:echarts_flutter_plus/echarts_flutter_plus_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

/// EChartsFlutterPlus Web Implementation - Optimized for Dart 3.7.0+
class EchartsFlutterPlusWeb extends EchartsFlutterPlusPlatform {
  /// Platform plugin registration (empty - widget handles views)
  static void registerWith(Registrar registrar) {
    // Platform views registered dynamically per widget instance
  }

  @override
  Future<String?> getPlatformVersion() async {
    return web.window.navigator.userAgent;
  }
}

/// ECharts JS Interop - Optimized for dart:js_interop
@JS('echarts')
external JSObject? get _echarts;

@JS('echarts.init')
external JSObject _echartsInit(web.Element el, [String? theme, JSAny? opts]);

@JS('eval')
external JSAny? _evaluateJS(JSString code);

@JS('JSON.parse')
external JSObject _jsParseJson(String json);

extension EChartsInterop on JSObject {
  external void setOption(JSAny? option, [bool? notMerge]);
  external void dispose();
  external void resize();
  external void on(JSString eventName, JSFunction callback);
  external void off(JSString eventName, [JSFunction? callback]);
}

/// Main ECharts Web Widget - Production Optimized
class EChartsWebView extends StatefulWidget {
  /// The ECharts chart configuration option, represented as a string.
  ///
  /// **JSON Mode** (`rawOption: false`): Pure JSON, no functions
  /// **Raw JS Mode** (`rawOption: true`): Full JS with formatters/renderItem
  final String option;

  /// `true` = Raw JS object literal (supports functions), `false` = JSON only
  final bool rawOption;

  /// Chart container width (pixels)
  final double width;

  /// Chart container height (pixels)
  final double height;

  /// ECharts theme (light/dark)
  final ChartThemeMode? theme;

  /// Enable debug logging
  final bool enableLogger;

  /// Custom error UI builder
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  /// ECharts JS load timeout (seconds)
  final int loadTimeoutSeconds;

  /// Force chart reload when changed
  final int reload;

  /// ECharts init options (renderer, devicePixelRatio, etc.)
  final JSAny? initOptions;

  /// Event callbacks: {'click': (params) => {}, ...}
  final Map<EChartsEvent, void Function(dynamic)>? onEvents;

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
  web.Element? _container;
  JSObject? _chart;
  late final String _viewType;
  static Future<void>? _echartsLoader;
  static int _instanceCounter = 0;
  Object? _lastError;
  StackTrace? _lastStack;

  /// Production security patterns (blocks XSS)
  static final _unsafePatterns = <RegExp>[
    RegExp(
      r'window|document|eval|fetch|XMLHttpRequest|WebSocket|postMessage',
      caseSensitive: false,
    ),
    RegExp(
      r'localStorage|sessionStorage|location|constructor|__proto__',
      caseSensitive: false,
    ),
    RegExp(
      r'setTimeout|setInterval|<script|import\(|require\(',
      caseSensitive: false,
    ),
    RegExp(r'while\s*\(true\)|for\s*\(\s*;;', caseSensitive: false),
  ];

  /// Validates option string security
  bool get _isSafeOption => _isSafeOptionStr(widget.option);

  bool _isSafeOptionStr(String option) {
    for (final pattern in _unsafePatterns) {
      if (pattern.hasMatch(option)) {
        _log('Blocked unsafe token: ${pattern.pattern}');
        return false;
      }
    }
    return !RegExp(
      r'\b(new\s+Function|while\s*\(true\)|for\s*\(\s*;;\))',
    ).hasMatch(option);
  }

  /// Lazy-loads ECharts 5.5.0 from CDN
  static Future<void> _ensureEchartsLoaded({
    bool enableLogger = false,
    int timeoutSeconds = 12,
  }) async {
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

    int attempts = 0;
    void poll() {
      attempts++;
      if (_echarts != null) {
        if (enableLogger) _logStatic('ECharts loaded in ${attempts * 100}ms');
        completer.complete();
        return;
      }
      if (attempts < timeoutSeconds * 10) {
        Timer(const Duration(milliseconds: 100), poll);
      } else {
        completer.completeError(TimeoutException('ECharts load timeout'));
      }
    }

    poll();

    _echartsLoader = completer.future;
    return _echartsLoader!;
  }

  static void _logStatic(String msg) => debugPrint('[ECharts] $msg');

  void _log(Object? msg) =>
      widget.enableLogger
          ? debugPrint('[ECharts:${_instanceCounter}] $msg')
          : null;

  @override
  void initState() {
    super.initState();
    _viewType = 'echarts-${_instanceCounter++}';
    _prepareContainer();
    _registerViewFactory();
    _initChart();
  }

  void _prepareContainer() {
    _container = web.document.createElement('div');
    _container!.setAttribute('style', '''
      width: ${widget.width}px;
      height: ${widget.height}px;
      position: relative;
      overflow: hidden;
    ''');
  }

  void _registerViewFactory() {
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _container!,
    );
  }

  Future<void> _initChart() async {
    try {
      await _ensureEchartsLoaded(
        enableLogger: widget.enableLogger,
        timeoutSeconds: widget.loadTimeoutSeconds,
      );

      if (!_isSafeOption) {
        throw Exception('Unsafe chart option rejected');
      }

      if (mounted) _renderChart();
    } catch (e, st) {
      if (mounted) {
        setState(() {
          _lastError = e;
          _lastStack = st;
        });
      }
    }
  }

  JSAny? _parseOption() =>
      widget.rawOption
          ? _parseRawOption(widget.option)
          : _jsParseJson(widget.option);

  JSAny? _parseRawOption(String option) {
    final jsCode = '(function(){return $option})()'.toJS;
    return _evaluateJS(jsCode);
  }

  void _renderChart() {
    _chart?.dispose();

    if (_echarts == null) {
      _log('ECharts not loaded');
      return;
    }

    try {
      final option = _parseOption();
      if (option == null) throw Exception('Failed to parse chart option');

      _chart = _echartsInit(
        _container!,
        widget.theme?.name ?? 'light',
        widget.initOptions,
      );

      _chart!.setOption(option, true);
      if (widget.onEvents?.isNotEmpty == true) _setupEvents();

      if (mounted) setState(() => _lastError = null);
    } catch (e, st) {
      _log('Render error: $e');
      if (mounted) {
        setState(() {
          _lastError = e;
          _lastStack = st;
        });
      }
    }
  }

  void _setupEvents() {
    // ✅ Skip ONLY integration tests (FLUTTER_TEST env var)
    if (const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false)) {
      _log('Skipping events during integration tests');
      return;
    }

    if (widget.onEvents == null || widget.onEvents!.isEmpty) {
      return;
    }

    // Events work in debug/profile/release ✅
    widget.onEvents!.forEach((event, callback) {
      final eventName = event.name.toJS;
      final JSFunction handler =
          ((JSAny? params) {
                try {
                  callback(params);
                } catch (e) {
                  _log('Event handler error: $e');
                }
              }).toJS
              as JSFunction;

      _chart!.on(eventName, handler);
    });
  }

  @override
  void didUpdateWidget(EChartsWebView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.reload != widget.reload) {
      _initChart();
      return;
    }

    if (oldWidget.option != widget.option ||
        oldWidget.rawOption != widget.rawOption ||
        oldWidget.theme != widget.theme) {
      _renderChart();
    }

    if (oldWidget.width != widget.width || oldWidget.height != widget.height) {
      _container?.setAttribute('style', '''
        width: ${widget.width}px;
        height: ${widget.height}px;
        position: relative;
        overflow: hidden;
      ''');
      _chart?.resize();
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
      return widget.errorBuilder?.call(context, _lastError!, _lastStack) ??
          const SizedBox.shrink();
    }
    return HtmlElementView(viewType: _viewType);
  }
}
