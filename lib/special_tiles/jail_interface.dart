import 'package:flutter/material.dart';
import 'package:business_game/logic/dice.dart';

class JailInterface extends StatefulWidget {
  final Function(bool) onExitJail;

  const JailInterface({super.key, required this.onExitJail});

  @override
  JailInterfaceState createState() => JailInterfaceState();
}

class JailInterfaceState extends State<JailInterface>
    with SingleTickerProviderStateMixin {
  int turnsLeft = 3;
  bool isFree = false;
  bool canRoll = true;
  String message = "Roll the dice! You have 3 chances.";
  late AnimationController _lightEffectController;
  late Animation<Color?> _lightEffectAnimation;

  @override
  void initState() {
    super.initState();
    _lightEffectController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _lightEffectAnimation = ColorTween(
      begin: Colors.redAccent.withAlpha(90),
      end: Colors.blueAccent.withAlpha(90),
    ).animate(_lightEffectController);
  }

  @override
  void dispose() {
    _lightEffectController.dispose();
    super.dispose();
  }

  void handleDiceRoll(int dice1, int dice2, int total) {
    if (turnsLeft > 0) {
      setState(() {
        turnsLeft--;
      });

      if (dice1 == dice2) {
        message = "🎉 Lucky! You rolled a double and are free!";
        isFree = true;
      } else if (turnsLeft == 0) {
        message = "😞 No double! You must stay in jail.";
      } else {
        message = "❌ Try again! Turns left: $turnsLeft";
      }

      if (turnsLeft == 0 || isFree) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              canRoll = false;
            });
            widget.onExitJail(isFree);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _lightEffectAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _lightEffectAnimation.value!,
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          const Text(
            "🚔 You're in JAIL!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "⏳ Turns Left: $turnsLeft",
            style: const TextStyle(fontSize: 18, color: Colors.orange),
          ),
          const SizedBox(height: 10),
          if (canRoll) DiceRoller(onRoll: handleDiceRoll),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              message,
              key: ValueKey<String>(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isFree ? Colors.greenAccent : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (!canRoll)
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              label: const Text("Close"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
        ],
      ),
    );
  }
}

void showJailInterface(BuildContext context, Function(bool) onExitJail) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: JailInterface(onExitJail: onExitJail),
      );
    },
  );
}
