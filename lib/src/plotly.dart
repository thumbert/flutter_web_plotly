import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/src/plot.dart';
import 'package:web/web.dart' as web;
import 'package:flutter_web_plotly/src/fakeui/fake_platformviewregistry.dart'
    if (dart.library.html) 'dart:ui_web' as ui;

///
/// See https://github.com/senthilnasa/high_chart/blob/master/lib/src/web/high_chart.dart
///

class Plotly extends StatefulWidget {
  Plotly({
    required this.viewId,
    required this.traces,
    required this.layout,
    this.displaylogo = false,
    this.displayModeBar,
    this.editable,
    this.linkText,
    this.responsive = true,
    this.showLink = false,
    this.staticPlot,
    this.scrollZoom,
    super.key,
  }) {
    chartDiv = web.HTMLDivElement()..id = viewId;
    bodyElement.append(chartDiv);
    ui.platformViewRegistry.registerViewFactory(
        viewId,
        (viewId) => bodyElement
          ..style.width = '100%'
          ..style.height = '100%');
    plot = Plot(chartDiv, traces, layout,
        displaylogo: displaylogo,
        displayModeBar: displayModeBar,
        editable: editable,
        linkText: linkText,
        responsive: responsive,
        showLink: showLink,
        staticPlot: staticPlot,
        scrollZoom: scrollZoom);
  }

  /// the viewId should be unique across elements
  final String viewId;
  final List<Map<String, dynamic>> traces;
  final Map<String, dynamic> layout;

  final bool displaylogo; //: false,
  /// Set this to [false] if you don't need the mode bar
  final bool? displayModeBar;

  /// If [true] the chart title, axis labels, and trace names in the legend are
  /// editable
  final bool? editable;
  final String? linkText;

  /// Make the plot responsive to window size
  final bool responsive;
  final bool showLink;
  final bool? staticPlot;

  /// If [true] zoom in and out of the plot by using the mousewheel
  final bool? scrollZoom;

  final bodyElement = web.HTMLBodyElement();

  /// Where the chart will be embedded
  late final web.HTMLDivElement chartDiv;
  late final Plot plot;

  /// Add new traces at the [positionIndices] positions.
  void addTraces(List<Map<String, dynamic>> traces, List<int> positionIndices) {
    PlotlyExt.addTraces(chartDiv, traces.jsify() as JSObject,
        positionIndices.jsify() as JSArray);
  }

  /// Delete the traces at this [index]
  void deleteTraces(List<int> positionIndices) {
    PlotlyExt.deleteTraces(chartDiv, positionIndices.jsify() as JSArray);
  }

  /// See https://github.com/plotly/plotly.js/blob/master/src/plot_api/to_image.js
  /// The [format] can be one of ```'png', 'jpeg', 'webp', 'svg', 'full-json'```.
  void downloadImage(
      {required String filename,
      required int width,
      required int height,
      String format = 'png',
      num scale = 1,
      bool imageDataOnly = false,
      bool setBackground = false}) {
    var options = {
      'filename': filename,
      'width': width,
      'height': height,
      if (format != 'png') 'format': format,
      if (scale != 1) 'scale': scale,
      if (!imageDataOnly) 'imageDataOnly': imageDataOnly,
      if (!setBackground) 'setBackground': setBackground,
    };
    PlotlyExt.downloadImage(chartDiv, options.jsify() as JSObject);
  }

  /// Extend existing traces at the [positionIndices] positions.
  void extendTraces(
      Map<String, dynamic> update, List<int> positionIndices, int maxPoints) {
    PlotlyExt.extendTraces(chartDiv, update.jsify() as JSObject,
        positionIndices.jsify() as JSArray, maxPoints.toJS);
  }

  /// Delete the traces at this [index]
  void moveTraces(List<int> currentIndices, List<int> newIndices) {
    PlotlyExt.moveTraces(chartDiv, currentIndices.jsify() as JSArray,
        newIndices.jsify() as JSArray);
  }

  /// Add values at the beginning of the trace for trace at [positionIndices].
  void prependTraces(
      Map<String, dynamic> update, List<int> positionIndices, int maxPoints) {
    PlotlyExt.prependTraces(chartDiv, update.jsify() as JSObject,
        positionIndices.jsify() as JSArray, maxPoints.toJS);
  }

  /// For example:
  /// ```
  ///   f = (JSAny? e) => print('Hi!'));
  /// ```
  void onClick(void Function(JSObject) f) {
    plot.proxy.on('plotly_click'.toJS, f.toJS);
  }

  void onHover(void Function(JSObject) f) {
    plot.proxy.on('plotly_hover'.toJS, f.toJS);
  }

  void onRelayout(void Function(JSObject) f) {
    plot.proxy.on('plotly_relayout'.toJS, f.toJS);
  }

  void onUnhover(void Function(JSObject) f) {
    plot.proxy.on('plotly_unhover'.toJS, f.toJS);
  }

  /// An efficient way of updating just the layout of a plot.
  void relayout(Map<String, dynamic> object) {
    PlotlyExt.relayout(chartDiv, object.jsify() as JSObject);
  }

  /// An efficient means of changing parameters in the data array. When
  /// restyling, you may choose to have the specified changes effect as
  /// many traces as desired. The update is given as a single [Map] and
  /// the traces that are effected are given as a list of traces indices.
  void restyle(Map<String, dynamic> object, List<int> traceIndex) {
    PlotlyExt.restyle(
        chartDiv, object.jsify() as JSObject, traceIndex.jsify() as JSArray);
  }

  void redraw(void Function() f) {
    plot.proxy.on('plotly_redraw'.toJS, f.toJS);
  }

  /// An efficient means of updating both the data array and layout object in
  /// an existing plot, basically a combination of Plotly.restyle and Plotly.relayout.
  void update(Map<String, dynamic> dataUpdate,
      Map<String, dynamic> layoutUpdate, List<int> traceIndices) {
    PlotlyExt.update(chartDiv, dataUpdate.jsify() as JSObject,
        layoutUpdate.jsify() as JSObject, traceIndices.jsify() as JSArray);
  }


  @override
  State<StatefulWidget> createState() => _PlotlyState();
}

class _PlotlyState extends State<Plotly> {
  Plot? plot;

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: widget.viewId);
  }
}
