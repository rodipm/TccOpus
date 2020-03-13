import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Widget> movableItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            movableItems.add(SampleEIP());
            // movableItems.add(MoveableStackItem());
          });
        },
      ),
      body: Stack(
        children: [Lines(), ...movableItems],
      ),
    );
  }
}

class MoveableStackItem extends StatefulWidget {
  final Widget childContents;
  MoveableStackItem(this.childContents);
  @override
  _MoveableStackItemState createState() => _MoveableStackItemState();
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;
  Color color;

  _MoveableStackItemState();

  @override
  void initState() {
    color = Colors.blue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onTap: () => print("b"),
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        child: widget.childContents,
      ),
    );
  }
}

class SampleEIP extends MoveableStackItem {
  SampleEIP()
      : super(Container(
            width: 100,
            height: 100,
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  color: Colors.blue,
                )
              ],
            )));
}

class Lines extends StatefulWidget {
  const Lines({Key key}) : super(key: key);

  @override
  createState() => _LinesState();
}

class _LinesState extends State<Lines> {
  Offset start;
  Offset end;

  @override
  build(_) => GestureDetector(
        onTap: () => print('t'),
        onPanStart: (details) {
          print(details.localPosition);
          setState(() {
            start = details.localPosition;
            end = null;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            end = details.localPosition;
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: LinesPainter(start, end),
        ),
      );
}

class LinesPainter extends CustomPainter {
  final Offset start, end;

  LinesPainter(this.start, this.end);

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || end == null) return;
    canvas.drawLine(
        start,
        end,
        Paint()
          ..strokeWidth = 4
          ..color = Colors.redAccent);
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
