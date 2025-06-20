import 'package:flutter/material.dart';
import 'line_and_scatter.dart';
import 'plot_interactions.dart';
import 'plot_with_slider.dart';
import 'redraw_plotly.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plotly examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Plotly examples'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Scrollbar(
          controller: controller,
          // thumbVisibility: true,
          child: ListView(
            controller: controller,
            children: const [
              LineAndScatter(),
              DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: SizedBox(
                    height: 4,
                  )),
              PlotInteractions(),
              DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: SizedBox(
                    height: 4,
                  )),
              PlotWithSlider(),
              DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: SizedBox(
                    height: 4,
                  )),
              ChartWithAsyncData(),
            ],
          ),
        ),
      ),
    );
  }
}
