import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:business_game/logic/chance.dart';
import 'package:business_game/models/chance_data.dart';
import 'package:provider/provider.dart';

bool isChanceDialogOpen = false;

class ChanceInterface extends StatefulWidget {
  final Player player;
  const ChanceInterface({super.key, required this.player});

  @override
  ChanceInterfaceState createState() => ChanceInterfaceState();
}

class ChanceInterfaceState extends State<ChanceInterface> {
  List<Chance> randomChances = getRandomChances().take(2).toList();
  List<bool> flippedCards = [false, false];
  List<FlipCardController> controllers =
      List.generate(2, (_) => FlipCardController());

  void _onCardSelected(int index) {
    if (!flippedCards[index]) {
      setState(() {
        flippedCards = [true, true];
      });
      controllers[index].toggleCard();

      Chance selectedChance = randomChances[index];
      _applyChanceEffect(selectedChance);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  void _applyChanceEffect(Chance chance) {
    final gameController = Provider.of<GameController>(context, listen: false);
    String type = chance.category;
    if (type == 'loss') {
      gameController.updatePlayerMoney(widget.player, -chance.value);
    } else if (type == 'profit') {
      gameController.updatePlayerMoney(widget.player, chance.value);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = screenWidth * 0.34;
    double cardHeight = screenHeight * 0.26;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(2, (index) {
              return Flexible(
                child: FlipCard(
                  controller: controllers[index],
                  flipOnTouch: false,
                  direction: FlipDirection.HORIZONTAL,
                  front: GestureDetector(
                    onTap: () {
                      if (!flippedCards.contains(true)) {
                        _onCardSelected(index);
                      }
                    },
                    child: Container(
                      width: cardWidth,
                      height: cardHeight,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/CardBack.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  back: Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 253, 228),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      randomChances[index].description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

void showChanceDialog(BuildContext context, Player player) {
  if (isChanceDialogOpen) return;
  isChanceDialogOpen = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: ChanceInterface(player: player),
      );
    },
  ).then((_) {
    isChanceDialogOpen = false;
  });
}
