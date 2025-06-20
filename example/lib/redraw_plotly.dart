import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/flutter_web_plotly.dart';

/// An example to show how to deal with new plots that need to be updated
/// from different widgets!
///
/// You need to provide a unique key and to have a unique div for the plotly
/// chart.
///
class ChartWithAsyncData extends StatefulWidget {
  const ChartWithAsyncData({super.key});

  @override
  createState() => _ChartWithAsyncDataState();
}

class _ChartWithAsyncDataState extends State<ChartWithAsyncData> {
  List<String> points = [
    "Item 1",
    "Item 2",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12,
        ),
        ElevatedButton(
          child: const Text("Add Point"),
          onPressed: () => setState(() {
            points.add("Item ${points.length + 1}");
          }),
        ),
        WidgetB(
          key: UniqueKey(), // <---------  NOTE will need a unique key
          count: points.length,
        ),
      ],
    );
  }
}

class WidgetB extends StatefulWidget {
  const WidgetB({super.key, required this.count});
  final int count;

  @override
  createState() => _WidgetBState();
}

class _WidgetBState extends State<WidgetB> {
  late int count;
  late Plotly plotly;

  @override
  void initState() {
    count = widget.count;
    var aux = DateTime.now().hashCode;
    plotly = Plotly(
      viewId: 'plotly-point-$aux', // <-------- NOTE the name of the div!
      traces: [
        {
          'x': List.generate(count, (i) => i),
          'y': List.generate(count, (i) => i * i),
          'mode': 'lines',
        }
      ],
      layout: {
        'width': 500,
        'height': 400,
        'title': 'There are $count points',
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 500, height: 400, child: plotly);
  }
}
