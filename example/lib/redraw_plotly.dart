import 'package:flutter/material.dart';
import 'package:flutter_web_plotly/flutter_web_plotly.dart';

/// An example to show how to deal with new plots that need to be updated
/// from different widgets!
///
/// You need to provide a unique key and to have a unique div for the plotly
/// chart.
///
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: WidgetA(),
        ),
      ),
    );
  }
}

class WidgetA extends StatefulWidget {
  const WidgetA({Key? key}) : super(key: key);

  @override
  createState() => _WidgetAState();
}

class _WidgetAState extends State<WidgetA> {
  List<String> points = [
    "Item 1",
    "Item 2",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
  const WidgetB({Key? key, required this.count}) : super(key: key);
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
      data: [
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
