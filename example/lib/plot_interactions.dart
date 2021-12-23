import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/flutter_web_plotly.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class PlotInteractions extends StatefulWidget {
  const PlotInteractions({Key? key}) : super(key: key);

  @override
  _PlotInteractionsState createState() => _PlotInteractionsState();
}

class _PlotInteractionsState extends State<PlotInteractions> {
  late Plotly plotly;
  final random = Random(10);
  late var traces = <Map<String, dynamic>>[];

  void addSeries() {
    var epsilon = List.generate(8760, (i) => random.nextDouble() - 0.5);
    var _current = 0.0;
    traces.add({
      'x': List.generate(8760, (i) => i),
      'y': epsilon.map((e) {
        _current += e;
        return _current;
      }),
      'mode': 'lines',
      'name': 'series${traces.length}',
    });
  }

  final layout = {'title': 'TimeSeries Plot', 'height': 650, 'width': 800};

  bool showHighlights = true;
  String relayoutOutput = '';

  @override
  void initState() {
    // start with two series
    addSeries();
    addSeries();
    plotly = Plotly(viewId: 'timeseries', data: traces, layout: layout);
    // plotly.plot.on('plotly_relayout').
    plotly.plot.onRelayout.forEach((e) {
      // print(e);
      // e is a JsObject, not a Dart Map so you need to extract contents by hand
      var keys = js.context['Object'].callMethod('keys', [e]) as List;
      // print(js.context['Object'].callMethod('keys', [e]));
      setState(() {
        if (keys.contains('xaxis.range[0]')) {
          // Pick up only the events when the axes get resized by a mouse
          // selection on the screen
          relayoutOutput += 'from: ' +
              e['xaxis.range[0]'].toString() + // a double
              ' to: ' +
              e['xaxis.range[1]'].toString(); // a double
        } else {
          relayoutOutput = '';
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Show various interactions with the plot',
          style: TextStyle(fontSize: 24),
        ),
        // const Text('Click on the + button to add another timeseries'),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    addSeries();
                    plotly.addTrace(traces.last);
                  },
                  child: const Text('Add Series')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    plotly.deleteTrace(traces.length - 1);
                    traces.removeAt(traces.length - 1);
                  },
                  child: const Text('Delete Series')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (showHighlights) {
                      plotly.layout['shapes'] = [
                        {
                          'type': 'rect',
                          'xref': 'x',
                          'yref': 'paper',
                          'x0': 720,
                          'y0': 0,
                          'x1': 2150,
                          'y1': 1,
                          'fillcolor': '#800000',
                          'opacity': 0.2,
                          'line': {
                            'width': 0,
                          }
                        },
                        {
                          'type': 'rect',
                          'xref': 'x',
                          'yref': 'paper',
                          'x0': 5120,
                          'y0': 0,
                          'x1': 6350,
                          'y1': 1,
                          'fillcolor': '#800000',
                          'opacity': 0.2,
                          'line': {
                            'width': 0,
                          }
                        },
                      ];
                    } else {
                      plotly.layout['shapes'] = [];
                    }
                    plotly.relayout(plotly.layout);
                    showHighlights = showHighlights ? false : true;
                  },
                  child: const Text('Relayout')),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        const Text('Select an area on the chart with the mouse ...'),
        Text('The xAxis selection is $relayoutOutput'),
        SizedBox(height: 650, width: 800, child: plotly),
      ],
    );
  }
}
