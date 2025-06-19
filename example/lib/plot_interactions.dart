import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/flutter_web_plotly.dart';

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
    plotly = Plotly(viewId: 'timeseries', traces: traces, layout: layout);
    plotly.onRelayout((JSObject data) {
      if (data.hasProperty('xaxis.range[0]'.toJS).toDart) {
        var x0 =
            (data.getProperty('xaxis.range[0]'.toJS) as JSNumber).toDartDouble;
        var x1 =
            (data.getProperty('xaxis.range[1]'.toJS) as JSNumber).toDartDouble;
        setState(() {
          relayoutOutput =
              'Selected xaxis from: (${x0.toStringAsFixed(2)}, ${x1.toStringAsFixed(2)})';
        });
      } else {
        setState(() {
          relayoutOutput = 'Nothing selected';
        });
      }
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
                    plotly.addTraces([traces.last], [traces.length - 1]);
                  },
                  child: const Text('Add Series')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    plotly.deleteTraces([traces.length - 1]);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    // the data property contains the traces
                    var data =
                        (plotly.plot.proxy.getProperty('data'.toJS) as JSArray)
                            .toDart;
                    // get the 'y' of the first trace
                    var y =
                        ((data[0] as JSObject).getProperty('y'.toJS) as JSArray)
                            .toDart;
                    var n = y.length;
                    // append 2000 hours of observations to the end of the series
                    var epsilon =
                        List.generate(2000, (i) => random.nextDouble() - 0.5);
                    var current = (y.last as JSNumber).toDartDouble;
                    var ext = {
                      'x': [List.generate(2000, (i) => n + i)],
                      'y': [
                        epsilon.map((e) {
                          current += e;
                          return current;
                        }).toList()
                      ],
                    };
                    plotly.extendTraces(ext, [0], n + 2000);
                  },
                  child: const Text('Extend Series')),
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
