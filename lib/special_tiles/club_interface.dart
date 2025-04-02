import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';
import 'package:business_game/logic/dice.dart';
import 'package:flutter/material.dart';

void showClubBetSelectionDialog(
    BuildContext context, Function(int) onBetSelected) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Bet Amount"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<int>(
              value: 1000,
              items: [1000, 2000, 5000, 10000].map((amount) {
                return DropdownMenuItem(
                  value: amount,
                  child: Text("$amount Coins"),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onBetSelected(value);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (context.mounted) Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
        ],
      );
    },
  );
}

void showClubDiceRollingDialog(BuildContext context, List<Player> players,
    int totalPot, GameController gameController) {
  Map<Player, int> diceRolls = {};
  int currentPlayerIndex = 0;

  void rollForNextPlayer() {
    if (currentPlayerIndex < players.length) {
      Player player = players[currentPlayerIndex];

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(50),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${player.name}'s Turn - Roll the Dice",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    DiceRoller(
                      onRoll: (dice1, dice2, total) {
                        diceRolls[player] = total;

                        Future.delayed(const Duration(milliseconds: 400), () {
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            currentPlayerIndex++;

                            if (currentPlayerIndex < players.length) {
                              rollForNextPlayer();
                            } else {
                              determineClubWinner(
                                  context, diceRolls, totalPot, gameController);
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  rollForNextPlayer();
}

void determineClubWinner(BuildContext context, Map<Player, int> diceRolls,
    int totalPot, GameController gameController) {
  Player? winner;
  int highestRoll = 0;

  for (var entry in diceRolls.entries) {
    if (entry.value > highestRoll) {
      highestRoll = entry.value;
      winner = entry.key;
    }
  }

  if (winner != null) {
    gameController.updatePlayerMoney(winner, totalPot);
  } else {
    return;
  }

  if (context.mounted) {
    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(50),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Club Tile - Winner!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text("🏆 ${winner?.name} wins $totalPot coins!",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
