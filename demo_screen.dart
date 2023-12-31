import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wall_layout/flutter_wall_layout.dart';
import 'package:flutter_wall_layout/wall_builder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late bool _reversed;
  late Axis _direction;
  late int _nbLayers;
  late bool _wrapedOptions;
  bool _random = false;
  late List<Stone> _stones;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _reversed = false;
    _direction = Axis.horizontal;
    _nbLayers = 5;
    _controller.forward(from: 0);
    _wrapedOptions = true;
    _stones = _buildStonesList();
  }

  @override
  Widget build(BuildContext context) {
    // final backgroundColor = Theme.of(context).colorScheme.background;
    return buildWallLayout();
  }

  void onRandomClicked() {
    setState(() {
      _random = !_random;
      if (_random) {
        _stones = _buildRandomStonesList(_nbLayers);
      } else {
        _stones = _buildStonesList();
      }
    });
  }

  Widget buildOptions(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      alignment: Alignment.bottomRight,
      // vsync: this,
      child: Container(
        margin: const EdgeInsets.only(left: 32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6.0),
          ],
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!_wrapedOptions)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    __buildDivisionsOption(),
                    __buildDirectionOption(),
                    __buildReverseOption(),
                  ],
                ),
              ),
            FloatingActionButton(
              elevation: 0.0,
              highlightElevation: 0.0,
              onPressed: () => setState(() => _wrapedOptions = !_wrapedOptions),
              child: const Icon(Icons.build),
            ),
          ],
        ),
      ),
    );
  }

  Widget __buildDivisionsOption() {
    return _buildOption(
      "Layers",
      CupertinoSegmentedControl<int>(
        groupValue: _nbLayers,
        children: const {2: Text("2"), 3: Text("3"), 4: Text("4")},
        onValueChanged: (value) => setState(() {
          _controller.forward(from: 0.0);
          _nbLayers = value;
          if (_random) {
            _stones = _buildRandomStonesList(_nbLayers);
          }
        }),
      ),
    );
  }

  Widget __buildReverseOption() {
    return _buildOption(
      "Reverse",
      CupertinoSegmentedControl<bool>(
        groupValue: _reversed,
        children: const {false: Text("no"), true: Text("yes")},
        onValueChanged: (value) => setState(() {
          _controller.forward(from: 0.0);
          _reversed = value;
        }),
      ),
    );
  }

  Widget __buildDirectionOption() {
    return _buildOption(
      "Direction",
      CupertinoSegmentedControl<Axis>(
        groupValue: _direction,
        children: const {Axis.vertical: Text("vertical"), Axis.horizontal: Text("horizontal")},
        onValueChanged: (value) => setState(() {
          _controller.forward(from: 0.0);
          _direction = value;
        }),
      ),
    );
  }

  Widget _buildOption(String text, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 1,
            child: Text(text),
          ),
          Expanded(
            flex: 2,
            child: child,
          ),
        ],
      ),
    );
  }

  Widget buildWallLayout() {
    return WallLayout(
      wallBuilder: _random
          ? FillingHolesWallBuildHandler(
              context: context,
              childBuilder: (_) => DecoratedBox(
                decoration: BoxDecoration(color: const Color(0xffececee), borderRadius: BorderRadius.circular(12)),
              ),
            )
          : WallBuilder.standard(),
      scrollDirection: _direction,
      stones: _stones,
      reverse: _reversed,
      layersCount: _nbLayers,
    );
  }

  List<Stone> _buildRandomStonesList(int maxLayer) {
    Random r = Random();
    next() => r.nextInt(maxLayer) + 1;
    final colors = [
      Colors.red,
      Colors.greenAccent,
      Colors.lightBlue,
      Colors.purple,
      Colors.yellow,
      Colors.cyanAccent,
      Colors.orange,
      Colors.green,
      Colors.pink,
      Colors.blueAccent,
      Colors.amber,
      Colors.teal,
      Colors.lightGreenAccent,
      Colors.deepOrange,
      Colors.deepPurpleAccent,
      Colors.lightBlueAccent,
      Colors.limeAccent,
    ];
    return colors.map((color) {
      int width = next();
      int height = next();
      return Stone(
        id: colors.indexOf(color),
        width: width,
        height: height,
        child: __buildStoneChild(
          background: color,
          text: "${width}x$height",
          surface: (width * height).toDouble(),
        ),
      );
    }).toList();
  }

  List<Stone> _buildStonesList() {
    final data = [
      {"color": Colors.red, "width": 2, "height": 2},
      {"color": Colors.greenAccent, "width": 1, "height": 1},
      {"color": Colors.lightBlue, "width": 1, "height": 2},
      {"color": Colors.purple, "width": 2, "height": 1},
      {"color": Colors.yellow, "width": 1, "height": 1},
      {"color": Colors.cyanAccent, "width": 1, "height": 1},
      {"color": Colors.orange, "width": 2, "height": 2},
      {"color": Colors.green, "width": 1, "height": 1},
      {"color": Colors.pink, "width": 2, "height": 1},
      {"color": Colors.blueAccent, "width": 1, "height": 1},
      {"color": Colors.amber, "width": 1, "height": 2},
      {"color": Colors.teal, "width": 2, "height": 1},
      {"color": Colors.lightGreenAccent, "width": 1, "height": 1},
      {"color": Colors.deepOrange, "width": 1, "height": 1},
      {"color": Colors.deepPurpleAccent, "width": 2, "height": 2},
      {"color": Colors.lightBlueAccent, "width": 1, "height": 1},
      {"color": Colors.limeAccent, "width": 1, "height": 1},
    ];
    return data.map((d) {
      int width = d["width"] as int;
      int height = d["height"] as int;
      return Stone(
        id: data.indexOf(d),
        width: width,
        height: height,
        child: __buildStoneChild(
          background: d["color"] as Color,
          text: "${width}x$height",
          surface: (width * height).toDouble(),
        ),
      );
    }).toList();
  }

  Widget __buildStoneChild({required Color background, required String text, required double surface}) {
    return ScaleTransition(
      scale: CurveTween(curve: Interval(0.0, min(1.0, 0.25 + surface / 6.0))).animate(_controller),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [background, Color.alphaBlend(background.withOpacity(0.6), Colors.black)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 32.0)),
      ),
    );
  }
}

// Fill empty place with stone 1x1
class FillingHolesWallBuildHandler extends WallBuilder {
  final WallBuilder proxy = WallBuilder.standard();
  final BuildContext context;
  final WidgetBuilder childBuilder;

  FillingHolesWallBuildHandler({required this.childBuilder, required this.context}) : super();

  WallBlueprint _buildBlueprint(List<Stone> stones) {
    return proxy.build(mainAxisSeparations: mainAxisSeparations, reverse: reverse, direction: direction, stones: stones);
  }

  void _findHoles(WallBlueprint blueprint, Function(int x, int y) onHoleFound) {
    List<Rect> bounds = blueprint.stonesPosition
        .map((key, value) =>
            MapEntry(key, Rect.fromLTWH(value.x.toDouble(), value.y.toDouble(), key.width.toDouble(), key.height.toDouble())))
        .values
        .toList();
    for (int x = 0; x < blueprint.size.width; x++) {
      for (int y = 0; y < blueprint.size.height; y++) {
        Rect area = Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0);
        bounds.firstWhere(
          (element) => area.overlaps(element),
          orElse: () {
            onHoleFound(x, y);
            return area;
          },
        );
        bounds.add(area);
      }
    }
  }

  @override
  Map<Stone, StoneStartPosition> computeStonePositions(List<Stone> stones) {
    final blueprint = _buildBlueprint(stones);
    Map<Stone, StoneStartPosition> positions = blueprint.stonesPosition;
    int idStart = 10000;
    _findHoles(blueprint, (x, y) {
      final stone = Stone(
        height: 1,
        width: 1,
        id: idStart++,
        child: childBuilder.call(context),
      );
      positions[stone] = StoneStartPosition(x: x, y: y);
    });
    return positions;
  }
}
