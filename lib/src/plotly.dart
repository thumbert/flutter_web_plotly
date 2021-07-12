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

  Plotly({required this.viewId, required this.data, required this.layout});

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
    ui.platformViewRegistry
        .registerViewFactory(widget.viewId, (viewId) => bodyElement);
    Plot(divElement, widget.data, widget.layout);
    return HtmlElementView(viewType: widget.viewId);
  }
}
