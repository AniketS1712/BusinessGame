import 'package:flutter/material.dart';
import 'package:business_game/logic/dice.dart';

class JailInterface extends StatefulWidget {
  final Function(bool) onExitJail;

  const JailInterface({super.key, required this.onExitJail});

  @override
  JailInterfaceState createState() => JailInterfaceState();
}

class JailInterfaceState extends State<JailInterface> {
  int turnsLeft = 3;
  bool isFree = false;
  bool canRoll = true;
  String message = "Roll the dice! You have 3 chances.";

  void handleDiceRoll(int dice1, int dice2, int total) {
    if (turnsLeft > 0) {
      setState(() {
        turnsLeft--;
      });

      if (dice1 == dice2) {
        message = "🎉 Congratulations! You rolled a double and are free!";
        isFree = true;
      } else if (turnsLeft == 0) {
        message = "😞 You didn't roll a double. Stay in jail for 1 more turn.";
      } else {
        message = "❌ No double! Try again. Turns left: $turnsLeft";
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
      title: const Text(
        "🚔 You're caught and put in JAIL!",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "⏳ Turns Left: $turnsLeft",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          if (canRoll) DiceRoller(onRoll: handleDiceRoll),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isFree ? Colors.green : Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          if (!canRoll)
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
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
