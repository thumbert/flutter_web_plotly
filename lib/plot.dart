// @JS()
library plotly;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
// import 'package:js/js.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js';
import 'dart:async';

/// Interactive scientific chart.
class Plot {
  final JsObject? _plotly;
  final Element _container;
  final JsObject _proxy;

  /// Creates a new plot in an empty `<div>` element.
  ///
  /// A note on sizing: You can either supply height and width in layout, or
  /// give the `div` a height and width in CSS.
  Plot(Element container, List data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool? staticPlot,
      String? linkText,
      bool displaylogo: false,
      bool? displayModeBar,
      bool? scrollZoom})
      : _plotly = context['Plotly'],
        _container = container,
        _proxy = JsObject.fromBrowserObject(container) {
    if (_plotly == null) {
      throw StateError('plotly-latest.min.js not loaded');
    }
    var _data = JsObject.jsify(data);
    var _layout = JsObject.jsify(layout);
    var opts = {};
    opts['showLink'] = showLink;
    if (staticPlot != null) opts['staticPlot'] = staticPlot;
    if (linkText != null) opts['linkText'] = linkText;
    opts['displaylogo'] = displaylogo;
    if (displayModeBar != null) opts['displayModeBar'] = displayModeBar;
    if (scrollZoom != null) opts['scrollZoom'] = scrollZoom;
    var _opts = JsObject.jsify(opts);
    _plotly!.callMethod('newPlot', [_container, _data, _layout, _opts]);
  }

  /// Creates a new plot in an empty `<div>` element with the given id.
  ///
  /// A note on sizing: You can either supply height and width in layout, or
  /// give the `div` a height and width in CSS.
  factory Plot.id(String id, List data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool? staticPlot,
      String? linkText,
      bool displaylogo: false,
      bool? displayModeBar,
      bool? scrollZoom}) {
    var elem = document.getElementById(id)!;
    return Plot(elem, data, layout,
        showLink: showLink,
        staticPlot: staticPlot,
        linkText: linkText,
        displaylogo: displaylogo,
        displayModeBar: displayModeBar,
        scrollZoom: scrollZoom);
  }

  /// Creates a new plot in an empty `<div>` element with the given [selectors].
  ///
  /// A note on sizing: You can either supply height and width in layout, or
  /// give the `div` a height and width in CSS.
  factory Plot.selector(
      String selectors, List data, Map<String, dynamic> layout,
      {bool showLink: false,
      bool? staticPlot,
      String? linkText,
      bool displaylogo: false,
      bool? displayModeBar,
      bool? scrollZoom}) {
    var elem = document.querySelector(selectors)!;
    return new Plot(elem, data, layout,
        showLink: showLink,
        staticPlot: staticPlot,
        linkText: linkText,
        displaylogo: displaylogo,
        displayModeBar: displayModeBar,
        scrollZoom: scrollZoom);
  }

  get data => _proxy['data'];
  get layout => _proxy['layout'];

  Stream get onClick => on("plotly_click");
  Stream get onBeforeHover => on("plotly_beforehover");
  Stream get onHover => on("plotly_hover");
  Stream get onUnhover => on("plotly_unhover");

  Stream on(String eventType) {
    var ctrl = StreamController();
    _proxy.callMethod('on', [eventType, ctrl.add]);
    return ctrl.stream;
  }

  /// An efficient means of changing parameters in the data array. When
  /// restyling, you may choose to have the specified changes effect as
  /// many traces as desired. The update is given as a single [Map] and
  /// the traces that are effected are given as a list of traces indices.
  /// Note, leaving the trace indices unspecified assumes that you want
  /// to restyle *all* the traces.
  void restyle(Map aobj, [List<int>? traces]) {
    var args = [_container, JsObject.jsify(aobj)];
    if (traces != null) {
      args.add(JsObject.jsify(traces));
    }
    _plotly!.callMethod('restyle', args);
  }

  /// An efficient means of updating just the layout of a plot.
  void relayout(Map aobj) {
    _plotly!.callMethod('relayout', [_container, JsObject.jsify(aobj)]);
  }

  /// Adds a new trace to an existing plot at any location in its data array.
  void addTrace(Map trace, [int? newIndex]) {
    if (newIndex != null) {
      addTraces([trace], [newIndex]);
    } else {
      addTraces([trace]);
    }
  }

  /// Adds new traces to an existing plot at any location in its data array.
  void addTraces(List<Map> traces, [List<int>? newIndices]) {
    var args = [_container, JsObject.jsify(traces)];
    if (newIndices != null) {
      args.add(JsObject.jsify(newIndices));
    }
    _plotly!.callMethod('addTraces', args);
  }

  /// Removes a trace from a plot by specifying the index of the trace to be
  /// removed.
  void deleteTrace(int index) => deleteTraces([index]);

  /// Removes traces from a plot by specifying the indices of the traces to be
  /// removed.
  void deleteTraces(List<int> indices) {
    _plotly!.callMethod('deleteTraces', [_container, JsObject.jsify(indices)]);
  }

  /// Extend traces
  void extendTraces(Map aobj, List<int> indices) {
    var args = [_container, JsObject.jsify(aobj), JsObject.jsify(indices)];
    _plotly!.callMethod('extendTraces', args);
  }

  /// Reposition a trace in the plot. This will change the ordering of the
  /// layering and the legend.
  void moveTrace(int currentIndex, int newIndex) =>
      moveTraces([currentIndex], [newIndex]);

  /// Reorder traces in the plot. This will change the ordering of the
  /// layering and the legend.
  void moveTraces(List<int> currentIndices, List<int> newIndices) {
    _plotly!.callMethod('moveTraces', [
      _container,
      JsObject.jsify(currentIndices),
      JsObject.jsify(newIndices)
    ]);
  }

  /// Animates to frames.
  ///
  /// Parameter [frames] can be a single frame, array of
  /// frames, or group to which to animate. The intent is inferred by
  /// the type of the input. Valid inputs are:
  ///   * [String], e.g. 'groupname': animate all frames of a given `group` in
  ///     the order in which they are defined via [addFrames];
  ///   * [List<String>], e.g. ['frame1', frame2']: a list of frames by
  ///     name to which to animate in sequence;
  ///   * [Map], e.g {data: ...}: a frame definition to which to animate. The frame is not
  ///     and does not need to be added via [addFrames]. It may contain any of
  ///     the properties of a frame, including `data`, `layout`, and `traces`. The
  ///     frame is used as provided and does not use the `baseframe` property.
  ///   * [List<Map>], e.g. [{data: ...}, {data: ...}]: a list of frame objects,
  ///     each following the same rules as a single `object`.
  void animate(frames, [Map? opts]) {
    final args = <dynamic>[_container];
    args.add((frames is Iterable || frames is Map)
        ? JsObject.jsify(frames)
        : frames);
    if (opts != null) args.add(JsObject.jsify(opts));
    _plotly!.callMethod('animate', args);
  }

  /// Registers new frames.
  ///
  /// [frameList] is a list of frame definitions, in which each object includes any of:
  /// * name: {[String]} name of frame to add;
  /// * data: {[List<Map>]} trace data;
  /// * layout: {[Map]} layout definition;
  /// * traces: {[List<int>]} trace indices;
  /// * baseframe {[String]} name of frame from which this frame gets defaults.
  ///
  /// [indices] is an list of integer indices matching the respective frames in [frameList]. If not
  /// provided, an index will be provided in serial order. If already used, the frame
  /// will be overwritten.
  void addFrames(List<Map> frameList, [List? indices]) {
    var args = [_container, JsObject.jsify(frameList)];
    if (indices != null) args.add(JsObject.jsify(indices));
    _plotly!.callMethod('addFrames', args);
  }

  /// Deletes frames from plot by [indices].
  void deleteFrames(List<int> indices) {
    _plotly!.callMethod('deleteFrames', [_container, JsObject.jsify(indices)]);
  }

  /// Use redraw to trigger a complete recalculation and redraw of the graph.
  /// This is not the fastest way to change single attributes, but may be the
  /// simplest way. You can make any arbitrary change to the data and layout
  /// objects, including completely replacing them, then call redraw.
  void redraw() {
    _plotly!.callMethod('redraw', [_container]);
  }

  void purge() {
    _plotly!.callMethod('purge', [_container]);
  }

  /// A method for updating both the data and layout objects at once.
  void update(Map dataUpdate, Map layoutUpdate) {
    _plotly!.callMethod('update',
        [_container, JsObject.jsify(dataUpdate), JsObject.jsify(layoutUpdate)]);
  }

  static getSchema() => context['Plotly']['PlotSchema'].callMethod("get");
}
