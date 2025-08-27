/// Describes the built-in theme modes available for ECharts.
///
/// Use this enum to select between light and dark themes for the chart.
enum ChartThemeMode {
  /// Light color theme (default).
  light,

  /// Dark color theme.
  dark,
}

/// Extension helper on [ChartThemeMode] to retrieve the theme name string.
///
/// This string name is passed to the ECharts JS library initialization
/// and must match ECharts registered theme names.
extension ChartThemeModeExtension on ChartThemeMode {
  /// Gets the theme name string corresponding to the enum value.
  String get name {
    switch (this) {
      case ChartThemeMode.light:
        return 'light';
      case ChartThemeMode.dark:
        return 'dark';
    }
  }

  /// Creates a [ChartThemeMode] from a JS theme name string.
  ///
  /// Returns [ChartThemeMode.light] if the name is null or unrecognized.
  static ChartThemeMode fromName(String? name) {
    switch (name) {
      case 'dark':
        return ChartThemeMode.dark;
      case 'light':
      default:
        return ChartThemeMode.light;
    }
  }
}
