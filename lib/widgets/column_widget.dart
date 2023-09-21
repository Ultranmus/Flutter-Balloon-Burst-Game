import 'dart:async';
import 'dart:math';
import 'package:balloon_burst/providers.dart';
import 'package:balloon_burst/widgets/ballon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColumnWidget extends StatefulWidget {
  final int index;
  const ColumnWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<ColumnWidget> createState() => _ColumnWidgetState();
}

class _ColumnWidgetState extends State<ColumnWidget> {
  List<Widget> balloons = [];
  late double screenWidth;
  late double screenHeight;
  Random random = Random();
  int score = 0;

  bool randomColor() {
    bool color = random.nextBool();
    return color;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.index % 2 == 0) {
      balloons.add(Bubble(color: randomColor(), pop: pop, index: widget.index));

      if (widget.index != 0 && widget.index != 6) {
        balloons
            .add(Bubble(color: randomColor(), pop: pop, index: widget.index));
      }
    } else {
      balloons.add(Bubble(color: randomColor(), pop: pop, index: widget.index));

      balloons.add(Bubble(color: randomColor(), pop: pop, index: widget.index));
    }
  }

  pop(bool color, WidgetRef ref) {
    if (color == ref.read(colorProvider).selectedColor()) {
      ref.read(scoreProvider.notifier).update((state) => ++state);
    }

    Future.delayed(const Duration(seconds: 1), () {
      balloons.add(Bubble(color: randomColor(), pop: pop, index: widget.index));
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    balloons.clear();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(scrollbars: false),
      child: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: balloons,
          )),
    );
  }
}
