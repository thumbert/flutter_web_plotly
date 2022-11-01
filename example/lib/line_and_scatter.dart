import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/flutter_web_plotly.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class LineAndScatter extends StatefulWidget {
  const LineAndScatter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()  => _LineAndScatterState();
}

class _LineAndScatterState extends State<LineAndScatter> {
  // const LineAndScatter({Key? key}) : super(key: key);

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
    'hovermode': 'closest',  // this is needed to select the points
  };

  @override
  void initState() {
    super.initState();
    plotly = Plotly(viewId: 'line-and-scatter', data: traces, layout: layout);
    plotly.plot.onHover.forEach((e) {
      // print(e);
      // e is a JsObject, not a Dart Map so you need to extract contents by hand
      // not sure why I need to make it a list: [e]
      // var keys = js.context['Object'].callMethod('keys', [e]) as List;
      // print(keys); // [event, points, xaxes, yaxes, xvals, yvals]
      // print(e['points']); // [[object Object]]

      // get the keys of the object e['points']
      // var info = js.context['Object'].callMethod('keys', e['points']);
      // print(info); // [data, fullData, curveNumber, pointNumber, pointIndex, x, y, xaxis, yaxis]

      // get the values of the object e['points']
      var xs = js.context['Object'].callMethod('values', e['points']);
      // print(xs);
      var curveNumber = xs[2];
      // var pointNumber = xs[3]; // pointNumber is the same thing as pointIndex
      // var pointIndex = xs[4];
      var xCoordinate = xs[5];
      var yCoordinate = xs[6];
      // print('Mouse on curve $curveNumber, pointIndex: $pointIndex, x: $xCoordinate, y: $yCoordinate');

      setState(() {
        // Pick up only the events when the mouse is over a point
        // note that layout.hovermode = 'closest' for this to work
        message = '  Mouse hovers over point ($xCoordinate, $yCoordinate) on curve $curveNumber';
      });
    });

    plotly.plot.onUnhover.forEach((e) {
      setState(() {
        // reset it
        message = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8,),
        const Text('  Move the mouse over a data point to see a message'),
        const SizedBox(height: 8,),
        Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),),
        SizedBox(height: 650, width: 800, child: plotly),
      ],
    );
  }
}
