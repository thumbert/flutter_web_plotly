import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/src/plot.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter_web_plotly/src/fakeui/fake_platformviewregistry.dart'
    if (dart.library.html) 'dart:ui' as ui;

class Plotly extends StatefulWidget {
  /// the viewId should be unique across elements
  final String viewId;
  final List data;
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

  Plotly({
    required this.viewId,
    required this.data,
    required this.layout,
    this.displaylogo = false,
    this.displayModeBar,
    this.editable,
    this.linkText,
    this.responsive = true,
    this.showLink = false,
    this.staticPlot,
    this.scrollZoom,
    Key? key,
  }) : super(key: key) {
    divElement = DivElement()..id = viewId;
    bodyElement.append(divElement);
    ui.platformViewRegistry.registerViewFactory(
        viewId,
        (viewId) => bodyElement
          ..style.width = '100%'
          ..style.height = '100%');
    plot = Plot(divElement, data, layout,
        displaylogo: displaylogo,
        displayModeBar: displayModeBar,
        editable: editable,
        linkText: linkText,
        responsive: responsive,
        showLink: showLink,
        staticPlot: staticPlot,
        scrollZoom: scrollZoom);
  }

  final bodyElement = BodyElement();

  /// Where the chart will be embedded
  late final DivElement divElement;
  late final Plot plot;

  /// Adds a new trace to an existing plot at any location in its data array.
  void addTrace(Map trace, [int? newIndex]) => plot.addTrace(trace, newIndex);

  /// Adds new traces to an existing plot at any location in its data array.
  void addTraces(List<Map> traces, [List<int>? newIndices]) =>
      plot.addTraces(traces, newIndices);

  /// Removes a trace from a plot by specifying the index of the trace to be
  /// removed.
  void deleteTrace(int index) => plot.deleteTrace(index);

  /// Removes traces from a plot by specifying the indices of the traces to be
  /// removed.
  void deleteTraces(List<int> indices) => plot.deleteTraces(indices);

  /// An efficient means of changing parameters in the data array. When
  /// restyling, you may choose to have the specified changes effect as
  /// many traces as desired. The update is given as a single [Map] and
  /// the traces that are effected are given as a list of traces indices.
  /// Note, leaving the trace indices unspecified assumes that you want
  /// to restyle *all* the traces.
  void restyle(Map aobj, [List<int>? traces]) => plot.restyle(aobj, traces);

  /// An efficient means of updating just the layout of a plot.
  void relayout(Map aobj) => plot.relayout(aobj);

  /// A method for updating both the data and layout objects at once.
  void update(Map dataUpdate, Map layoutUpdate, [List<int>? indices]) =>
      plot.update(dataUpdate, layoutUpdate, indices);

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
