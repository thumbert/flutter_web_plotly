import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/flutter_web_plotly.dart';

class LineAndScatter extends StatelessWidget {
  const LineAndScatter({Key? key}) : super(key: key);

  static const data = [
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
    'width': 800
  };

  @override
  Widget build(BuildContext context) {
    return Plotly(viewId: 'line-and-scatter', data: data, layout: layout);
  }
}
