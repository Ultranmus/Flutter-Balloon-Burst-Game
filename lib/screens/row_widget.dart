import 'dart:async';
import 'dart:math';
import 'package:balloon_burst/providers.dart';
import 'package:balloon_burst/widgets/column_widget.dart';
import 'package:balloon_burst/widgets/score_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RowWidget extends ConsumerStatefulWidget {
  const RowWidget({super.key});

  @override
  ConsumerState<RowWidget> createState() => _RowWidgetState();
}

class _RowWidgetState extends ConsumerState<RowWidget>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _isInBackground = true;
      _timer.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _isInBackground = false;
      startTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late Timer _timer;
  bool _isInBackground = false;

  void startTimer() {
    bool color = ref.read(colorProvider).selectedColor();
    Future.delayed(const Duration(seconds: 1), () {
      Fluttertoast.showToast(
        msg: color ? 'red' : 'blue',
        backgroundColor: color ? Colors.red : Colors.blue,
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4,
      );
    });
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (timer.isActive && !_isInBackground) {
        bool newColor = Random().nextBool();
        Fluttertoast.showToast(
          msg: newColor ? 'red' : 'blue',
          backgroundColor: newColor ? Colors.red : Colors.blue,
          gravity: ToastGravity.SNACKBAR,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 4,
        );
        ref.read(colorProvider).updateColor(newColor);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) => ColumnWidget(index: index)),
            ),
          ),
        ),
        floatingActionButton: const ScoreButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }
}
