import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DiceRoller extends StatefulWidget {
  final void Function(int, int, int)? onRoll;

  const DiceRoller({super.key, this.onRoll});

  @override
  DiceRollerState createState() => DiceRollerState();
}

class DiceRollerState extends State<DiceRoller>
    with SingleTickerProviderStateMixin {
  int _dice1 = 1;
  int _dice2 = 1;
  bool _rolling = false;
  final Random _random = Random();
  final AudioPlayer _player = AudioPlayer();
  late AnimationController _rotationController;
  double _rotationDirection = 1.0; // +1 for clockwise, -1 for counterclockwise

  List<String> diceImages = [
    'assets/images/dice/dice_1.png',
    'assets/images/dice/dice_2.png',
    'assets/images/dice/dice_3.png',
    'assets/images/dice/dice_4.png',
    'assets/images/dice/dice_5.png',
    'assets/images/dice/dice_6.png',
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: -pi * 2, // Allows both directions
      upperBound: pi * 2,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _rollDice() async {
    if (_rolling) return;
    _rolling = true;

    await _player.play(AssetSource('audio/rolling-dice.mp3'));

    // Randomly choose rotation direction for each roll
    _rotationDirection = _random.nextBool() ? 1.0 : -1.0;

    int rollCount = 12;
    _rotationController.repeat();

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _dice1 = _random.nextInt(6) + 1;
        _dice2 = _random.nextInt(6) + 1;
      });

      rollCount--;
      if (rollCount == 0) {
        timer.cancel();
        _rotationController.stop();

        int total = _dice1 + _dice2;
        widget.onRoll?.call(_dice1, _dice2, total);
        _rolling = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedDice(_dice1),
            const SizedBox(width: 10),
            _buildAnimatedDice(_dice2),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _rollDice,
          child: const Text(
            'Roll Dice',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedDice(int value) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationDirection * _rotationController.value,
          child: child,
        );
      },
      child: Image.asset(
        diceImages[value - 1],
        width: 50,
        height: 50,
      ),
    );
  }
}
