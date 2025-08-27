/// Enumerates all supported ECharts JavaScript event names.
///
/// Use these values to subscribe to chart events in a type-safe manner
/// instead of raw strings.
///
/// Typical events include user interactions like clicks, mouse movements,
/// legend changes, zoom events, and more.
enum EChartsEvent {
  /// Fires when chart elements are clicked.
  click,

  /// Fires when chart elements are double-clicked.
  dblclick,

  /// Mouse button is pressed down.
  mousedown,

  /// Mouse pointer moves over the chart or elements.
  mousemove,

  /// Mouse button is released.
  mouseup,

  /// Mouse pointer enters an element.
  mouseover,

  /// Mouse pointer leaves an element.
  mouseout,

  /// Mouse pointer leaves the entire chart.
  globalout,

  /// Right-click context menu event.
  contextmenu,

  /// Fired when legend selection changes.
  legendselectchanged,

  /// Fired when any legend is selected.
  legendselected,

  /// Fired when any legend is unselected.
  legendunselected,

  /// Data zoom change event.
  datazoom,

  /// Timeline current index changed.
  timelinechanged,

  /// Timeline play state changed.
  timelineplaychanged,

  /// Chart is restored.
  restore,

  /// Data view changed.
  dataviewchanged,

  /// Magic type (chart type) changed.
  magictypechanged,

  /// Geo component selection changed.
  geoselectchanged,

  /// Geo component selected.
  geoselected,

  /// Geo component unselected.
  geoUnselected,

  /// Pie chart slice selection changed.
  pieselectchanged,

  /// Pie chart slice selected.
  piesselected,

  /// Pie chart slice unselected.
  pieUnselected,

  /// Map select changed event.
  mapselectchanged,

  /// Map area selected.
  mapselected,

  /// Map area unselected.
  mapUnselected,

  /// Axis area selected.
  axisareaselected,
}

/// Extension adding helper functionality to [EChartsEvent].
///
/// Provides string alias names that correspond exactly to ECharts JS event names.
extension EChartsEventExtension on EChartsEvent {
  /// Gets the corresponding string event name used in ECharts JavaScript API.
  ///
  /// Use this when subscribing or unsubscribing to events from your Dart code.
  String get name {
    switch (this) {
      case EChartsEvent.click:
        return 'click';
      case EChartsEvent.dblclick:
        return 'dblclick';
      case EChartsEvent.mousedown:
        return 'mousedown';
      case EChartsEvent.mousemove:
        return 'mousemove';
      case EChartsEvent.mouseup:
        return 'mouseup';
      case EChartsEvent.mouseover:
        return 'mouseover';
      case EChartsEvent.mouseout:
        return 'mouseout';
      case EChartsEvent.globalout:
        return 'globalout';
      case EChartsEvent.contextmenu:
        return 'contextmenu';
      case EChartsEvent.legendselectchanged:
        return 'legendselectchanged';
      case EChartsEvent.legendselected:
        return 'legendselected';
      case EChartsEvent.legendunselected:
        return 'legendunselected';
      case EChartsEvent.datazoom:
        return 'datazoom';
      case EChartsEvent.timelinechanged:
        return 'timelinechanged';
      case EChartsEvent.timelineplaychanged:
        return 'timelineplaychanged';
      case EChartsEvent.restore:
        return 'restore';
      case EChartsEvent.dataviewchanged:
        return 'dataviewchanged';
      case EChartsEvent.magictypechanged:
        return 'magictypechanged';
      case EChartsEvent.geoselectchanged:
        return 'geoselectchanged';
      case EChartsEvent.geoselected:
        return 'geoselected';
      case EChartsEvent.geoUnselected:
        return 'geoUnselected';
      case EChartsEvent.pieselectchanged:
        return 'pieselectchanged';
      case EChartsEvent.piesselected:
        return 'piesselected';
      case EChartsEvent.pieUnselected:
        return 'pieUnselected';
      case EChartsEvent.mapselectchanged:
        return 'mapselectchanged';
      case EChartsEvent.mapselected:
        return 'mapselected';
      case EChartsEvent.mapUnselected:
        return 'mapUnselected';
      case EChartsEvent.axisareaselected:
        return 'axisareaselected';
    }
  }
}
