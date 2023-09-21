import 'dart:async';
import 'package:balloon_burst/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../audio_service.dart';
import '../constants.dart';

class Bubble extends ConsumerStatefulWidget {
  final bool color;
  final Function pop;
  final int index;
  const Bubble(
      {Key? key, required this.color, required this.pop, required this.index})
      : super(key: key);

  @override
  ConsumerState<Bubble> createState() => _BubbleState();
}

class _BubbleState extends ConsumerState<Bubble> {
  bool show = false;
  bool shrink = true;
  bool visible = true;
  double size = 1;
  bool hasBeenTapped = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        show = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getSize() {
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (timer.isActive) {
        if (mounted) {
          setState(() {
            size = size <= 1 ? 1.5 : 0.6;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedSize(
      duration: const Duration(milliseconds: 700),
      child: show
          ? AnimatedSize(
              duration: const Duration(milliseconds: 700),
              child: shrink
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.index % 2 == 0
                            ? SizedBox(
                                height: screenHeight * 0.125,
                              )
                            : const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              visible = false;
                              Future.delayed(const Duration(milliseconds: 70),
                                  () {
                                shrink = false;
                              });
                              getSize();

                              if (!hasBeenTapped) {
                                if (ref.read(colorProvider).selectedColor() ==
                                    widget.color) {
                                  AudioService().playSound(Constants.sound);
                                }
                                widget.pop(widget.color, ref);
                                hasBeenTapped = true;
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  if (timer.isActive) {
                                    timer.cancel();
                                  }
                                });
                              }
                            });
                          },
                          child: AnimatedOpacity(
                            opacity: visible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                            child: Transform.scale(
                              scale: visible ? 1.0 : size, // Apply pop effect.
                              child: Image.network(
                                'https://clipart-library.com/images/kT8oBnMRc.png',
                                height: screenHeight * 0.4,
                                fit: BoxFit.cover,
                                width: screenWidth * 0.14,
                                color: widget.color ? Colors.red : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        widget.index % 2 != 0
                            ? SizedBox(
                                height: screenHeight * 0.125 * 1.3 * 0.3,
                              )
                            : const SizedBox(),
                      ],
                    )
                  : SizedBox(
                      width: screenWidth * 0.125,
                    ),
            )
          : SizedBox(
              height: screenHeight * 1.2,
              width: screenWidth * 0.125,
            ),
    );
  }
}
