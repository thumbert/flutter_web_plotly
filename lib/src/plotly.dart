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
    this.displaylogo: false,
    this.displayModeBar,
    this.editable,
    this.linkText,
    this.responsive: true,
    this.showLink: false,
    this.staticPlot,
    this.scrollZoom,
  });

  @override
  State<StatefulWidget> createState() => _PlotlyState();
}

class _PlotlyState extends State<Plotly> {
  final bodyElement = BodyElement();

  /// Where the chart will be embedded
  late final DivElement divElement;

  @override
  void initState() {
    super.initState();
    divElement = DivElement()..id = widget.viewId;
    bodyElement.append(divElement);
  }

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(
        widget.viewId,
        (viewId) => bodyElement
          ..style.width = '100%'
          ..style.height = '100%');
    Plot(divElement, widget.data, widget.layout,
        displaylogo: widget.displaylogo,
        displayModeBar: widget.displayModeBar,
        editable: widget.editable,
        linkText: widget.linkText,
        responsive: widget.responsive,
        showLink: widget.showLink,
        staticPlot: widget.staticPlot,
        scrollZoom: widget.scrollZoom);
    return HtmlElementView(viewType: widget.viewId);
  }
}
