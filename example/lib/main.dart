import 'package:flutter/material.dart';
import 'line_and_scatter.dart';
import 'plot_interactions.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Scrollbar(
          isAlwaysShown: true,
          child: ListView(
            children: const [
              SizedBox(height: 650, width: 800, child: LineAndScatter()),
              DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                  child: SizedBox(
                    height: 4,
                  )),
              PlotInteractions(),
              // Expanded(child: PlotInteractions()),
            ],
          ),
        ),
      ),
    );
  }
}
