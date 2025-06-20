@JS()
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class Plot {
  /// Creates a new plot in an empty `<div>` element.
  Plot(
    web.HTMLElement container,
    List<Map<String, dynamic>> traces,
    Map<String, dynamic> layout, {
    bool? displaylogo,
    bool? displayModeBar,
    bool? editable,
    String? linkText,
    bool? responsive,
    bool? showLink,
    bool? staticPlot,
    bool? scrollZoom,
  }) : proxy = container as PlotlyExt {
    config = makeOptions(
      displaylogo: displaylogo,
      displayModeBar: displayModeBar,
      editable: editable,
      linkText: linkText,
      responsive: responsive,
      showLink: showLink,
      staticPlot: staticPlot,
      scrollZoom: scrollZoom,
    );
    PlotlyExt.newPlot(
      container,
      traces.jsify() as JSObject,
      layout.jsify() as JSObject,
      config.jsify() as JSObject,
    );
  }

  final PlotlyExt proxy;
  late Map<String, dynamic> config;

  /// Create Plotly options
  Map<String, dynamic> makeOptions({
    bool? displaylogo,
    bool? displayModeBar,
    bool? editable,
    String? linkText,
    bool? responsive,
    bool? showLink,
    bool? staticPlot,
    bool? scrollZoom,
  }) {
    var opts = <String, dynamic>{};
    if (showLink != null) opts['showLink'] = showLink;
    if (editable != null) opts['editable'] = editable;
    if (staticPlot != null) opts['staticPlot'] = staticPlot;
    if (linkText != null) opts['linkText'] = linkText;
    if (displaylogo != null) opts['displaylogo'] = displaylogo;
    if (displayModeBar != null) opts['displayModeBar'] = displayModeBar;
    if (responsive != null) opts['responsive'] = responsive;
    if (scrollZoom != null) opts['scrollZoom'] = scrollZoom;
    return opts;
  }
}

/// See the corresponding JS API implementation here:
/// https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_api.js
@JS('Plotly')
extension type PlotlyExt(JSObject _) implements JSObject {
  external static void newPlot(
    web.HTMLElement gd,
    JSObject traces,
    JSObject layout,
    JSObject config,
  );

  /// Add new traces at the [positionIndices] positions.
  external static void addTraces(
    web.HTMLElement gd,
    JSObject newTraces,
    JSArray positionIndices,
  );

  /// Add new traces at the [positionIndices] positions.
  external static void deleteTraces(
    web.HTMLElement gd,
    JSArray positionIndices,
  );

  ///
  external static void downloadImage(web.HTMLElement gd, JSObject options);

  external static void extendTraces(
    web.HTMLElement gd,
    JSObject dataUpdate,
    JSArray positionIndices,
    JSNumber maxPoints,
  );

  external static void moveTraces(
    web.HTMLElement gd,
    JSArray currentIndices,
    JSArray newIndices,
  );

  external static void prependTraces(
    web.HTMLElement gd,
    JSObject dataUpdate,
    JSArray positionIndices,
    JSNumber maxPoints,
  );

  external void on(JSString name, JSFunction f);

  external static void react(
    web.HTMLElement gd,
    JSObject traces,
    JSObject layout,
    JSObject config,
  );

  external static void relayout(web.HTMLElement gd, JSObject data);

  external static void restyle(
    web.HTMLElement gd,
    JSObject data,
    JSArray traceIndex,
  );

  external static void update(
    web.HTMLElement gd,
    JSObject data,
    JSObject layout,
    JSArray traceIndices,
  );
}
