import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';
import 'package:business_game/logic/dice.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showClubBetSelectionDialog(
    BuildContext context, Function(int) onBetSelected) {
  int selectedBet = 1000;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("💰 Select Your Bet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [1000, 2000, 5000, 10000].map((amount) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (selectedBet == amount) ? Colors.orange : Colors.blueGrey,
                ),
                onPressed: () {
                  selectedBet = amount;
                  onBetSelected(amount);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (context.mounted) Navigator.of(context).pop();
                  });
                },
                child: Text("$amount Coins",
                    style: const TextStyle(color: Colors.white)),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
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
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🟢 Player Avatar with Glow Effect
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        player.name[0],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Player Name & Turn Indicator
                    Text(
                      "${player.name}'s Turn 🎲",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🎲 Your Existing Animated Dice Roller
                    DiceRoller(
                      onRoll: (dice1, dice2, total) {
                        diceRolls[player] = total;

                        Future.delayed(const Duration(milliseconds: 800), () {
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

                    const SizedBox(height: 10),

                    // ⏳ Rolling Indicator
                    const Text(
                      "Rolling...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
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
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(30),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/confetti.json',
                  width: 120,
                  repeat: true,
                ),
                const SizedBox(height: 10),
                const Text(
                  "🎉 Club Tile - Winner!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  "🏆 ${winner?.name} wins $totalPot coins!",
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Lottie.asset(
                  'assets/animations/coins.json',
                  width: 100,
                  repeat: false,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child:
                      const Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
