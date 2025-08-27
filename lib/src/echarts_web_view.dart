import 'dart:async';
import 'package:echarts_flutter_plus/echarts_flutter_plus_platform_interface.dart';
import 'package:echarts_flutter_plus/src/utils/theme_mode.dart';
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

@JS('JSON.parse')
external JSObject _jsParseJson(String json);

@JS('window.onEChartsEvent')
external set _onEChartsEvent(JSFunction f);

/// Extension to declare the JS methods you use on echarts instances
extension EChartsInterop on JSObject {
  external void setOption(JSAny option, [bool? notMerge]);
  external void dispose();
  external void resize();
  external void on(String eventName, JSFunction callback);
  external void off(String eventName, [JSFunction? callback]);
}

/// Flutter web widget embedding an Apache ECharts chart.
///
/// This widget renders an interactive ECharts chart using the Flutter web platform.
/// Use the [option] JSON string to configure chart data and styling.
///
/// Supports extensive configuration, custom themes, and event callbacks.
class EChartsWebView extends StatefulWidget {
  /// JSON string containing the ECharts option configuration.
  final String option;

  /// The width of the chart container in pixels.
  final double width;

  /// The height of the chart container in pixels.
  final double height;

  /// Optional theme mode for the chart.
  final ChartThemeMode? theme;

  /// Whether detailed debug logs should be printed to the console.
  final bool enableLogger;

  /// Optional widget builder to display a custom error UI.
  final Widget Function(BuildContext context, Object error, StackTrace? stack)?
  errorBuilder;

  /// Timeout in seconds for loading the ECharts JavaScript library.
  final int loadTimeoutSeconds;

  /// Increment this value to force a full reload and re-initialization of the chart.
  final int reload;

  /// Optional advanced initialization options passed as raw JS objects to [echarts.init].
  final JSAny? initOptions;

  /// Map of ECharts event names to Dart callbacks.
  final Map<String, void Function(dynamic params)>? onEvents;

  /// Creates an instance of [EChartsWebView].
  const EChartsWebView({
    super.key,
    required this.option,
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
              '[EChartsWebView] ECharts loaded after ${pollCount * 100}ms and $pollCount poll ticks',
            );
          }
          if (!completer.isCompleted) completer.complete();
          timer?.cancel();
        }
      } catch (_) {
        // continue polling silently
      }
    });

    Future.delayed(Duration(seconds: timeout), () {
      if (!completer.isCompleted) {
        timer?.cancel();
        if (enableLogger) {
          debugPrint(
            '[EChartsWebView] ERROR: ECharts JS did not load in $timeout seconds',
          );
        }
        completer.completeError(
          TimeoutException('ECharts JS did not load in time.'),
        );
      }
    });

    _echartsLoader = completer.future;
    return _echartsLoader!;
  }

  void _log(Object? message) {
    if (widget.enableLogger) {
      debugPrint('[EChartsWebView] $message');
    }
  }

  @override
  void initState() {
    super.initState();
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

  Future<void> _initChart() async {
    _log('Starting ECharts loader');
    try {
      await _loadEcharts(
        enableLogger: widget.enableLogger,
        timeout: widget.loadTimeoutSeconds,
      );
      _renderChart();
    } catch (error, stack) {
      _log('Error loading ECharts: $error');
      setState(() {
        _lastError = error;
        _lastStack = stack;
      });
    }
  }

  void _renderChart() {
    _log('Rendering chart');
    _chart?.dispose();
    if (_echarts != null) {
      try {
        final optionObj = _jsParseJson(widget.option);
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
      } catch (error, stack) {
        _log('Error parsing option or rendering chart: $error');
        setState(() {
          _lastError = error;
          _lastStack = stack;
        });
      }
    } else {
      _log('ECharts JS not present at rendering time');
    }
  }

  /// Sets up forwarding of ECharts JavaScript events to Dart callbacks.
  ///
  /// This method binds the Dart callbacks as JS functions directly on the ECharts instance.
  void _setupEventCallbacks() {
    if (_chart == null) {
      _log('Chart instance is null, cannot attach events.');
      return;
    }

    if (widget.onEvents == null || widget.onEvents!.isEmpty) {
      _log('No events to subscribe.');
      return;
    }

    widget.onEvents!.forEach((eventName, dartCallback) {
      // Convert Dart callback to JSFunction using toJS
      JSFunction jsCallback =
          ((JSAny params) {
            dartCallback(params);
          }).toJS;

      // Attach event on the chart instance
      _chart!.on(eventName, jsCallback);
    });

    // Optionally set the global JS event handler callback if used elsewhere
    _onEChartsEvent =
        ((String event, JSAny params) {
          if (widget.onEvents!.containsKey(event)) {
            widget.onEvents![event]!(params);
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
    if (oldWidget.option != widget.option) {
      try {
        final optionObj = _jsParseJson(widget.option);
        _chart?.setOption(optionObj, true);
        setState(() {
          _lastError = null;
          _lastStack = null;
        });
      } catch (error, stack) {
        _log('Error updating options: $error');
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
      _log('Chart error: $_lastError');
      return const SizedBox.shrink();
    }
    return HtmlElementView(viewType: _viewType);
  }
}
