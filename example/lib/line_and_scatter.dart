import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/flutter_web_plotly.dart';

class LineAndScatter extends StatefulWidget {
  const LineAndScatter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LineAndScatterState();
}

class _LineAndScatterState extends State<LineAndScatter> {
  late Plotly plotly;
  String message = '';

  static const traces = [
    {
      'x': [1, 2, 3, 4],
      'y': [10, 15, 13, 17],
      'mode': 'markers'
    },
    {
      'x': [2, 3, 4, 5],
      'y': [16, 5, 11, 10],
      'mode': 'lines'
    },
    {
      'x': [1, 2, 3, 4],
      'y': [12, 9, 15, 12],
      'mode': 'lines+markers'
    }
  ];

  static const layout = {
    'title': 'Line and Scatter Plot',
    'height': 650,
    'width': 800,
    'hovermode': 'closest', // this is needed to select the points
  };

  @override
  void initState() {
    super.initState();
    plotly = Plotly(viewId: 'line-and-scatter', traces: traces, layout: layout);
    plotly.onHover((JSObject data) {
      var points = (data.getProperty('points'.toJS) as JSArray).toDart;
      var pointNumber =
          ((points[0] as JSObject).getProperty('pointNumber'.toJS) as JSNumber)
              .toDartInt;
      var traceNumber =
          ((points[0] as JSObject).getProperty('curveNumber'.toJS) as JSNumber)
              .toDartInt;
      var xCoordinate =
          ((points[0] as JSObject).getProperty('x'.toJS) as JSNumber)
              .toDartDouble;
      var yCoordinate =
          ((points[0] as JSObject).getProperty('y'.toJS) as JSNumber)
              .toDartDouble;
      setState(() {
        message =
            'Hovering over point $pointNumber (x: $xCoordinate, y: $yCoordinate) of trace $traceNumber';
      });
    });
    plotly.onUnhover((JSObject data) {
      setState(() {
        message = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 8,
        ),
        const Text('  Move the mouse over a data point to see a message'),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.purple),
        ),
        // The plotly widget needs to be in a sized box.  
        SizedBox(height: 675, width: 800, child: plotly),
      ],
    );
  }
}
