import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class ScoreButton extends ConsumerWidget {
  const ScoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      child: Text('Score : ${ref.watch(scoreProvider)}'),
      onPressed: () {},
    );
  }
}
