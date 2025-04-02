import 'package:business_game/logic/dice.dart';
import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';
import 'package:business_game/ui/player_token.dart';
import 'package:flutter/material.dart';
import 'package:business_game/ui/tilewidget.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class BusinessBoard extends StatelessWidget {
  final List<Player> players;

  const BusinessBoard({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context, listen: false);
    final players = gameController.players;

    final Size boardsize = MediaQuery.sizeOf(context) * 0.9;
    final double width = boardsize.width / 13;
    final double height = boardsize.width / 6.5;
    final double cornertilesize = (boardsize.width / 13) * 2;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/board_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withAlpha(100),
          ),
          Center(
            child: SizedBox(
              width: boardsize.width,
              height: boardsize.width,
              child: Stack(
                children: [
                  BoardLayout(
                    boardSize: boardsize.width,
                    height: height,
                    width: width,
                    cornertilesize: cornertilesize,
                  ),
                  Center(
                    child: DiceRoller(
                      onRoll: (dice1, dice2, diceSum) {
                        gameController.updateDiceValues(dice1, dice2);
                        gameController.movePlayer(diceSum);
                      },
                    ),
                  ),
                  PlayerToken(
                    boardSize: boardsize.width,
                    players: players,
                    currentPlayerIndex: gameController.currentPlayerIndex,
                    gameController: gameController,
                    dice1: gameController.dice1,
                    dice2: gameController.dice2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BoardLayout extends StatelessWidget {
  final double boardSize;
  final double height;
  final double width;
  final double cornertilesize;

  const BoardLayout({
    super.key,
    required this.boardSize,
    required this.height,
    required this.width,
    required this.cornertilesize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left column (vertical tiles)
        ...List.generate(9, (index) {
          return Positioned(
            left: 14.3,
            bottom: (cornertilesize + (index * width)) - 14.2,
            child: Transform.rotate(
              angle: math.pi / 2,
              child: TileWidget(
                tileIndex: index + 1,
                width: width,
                height: height,
                rotationAngle: math.pi / -2,
              ),
            ),
          );
        }),

        // Right column (vertical tiles)
        ...List.generate(9, (index) {
          return Positioned(
            right: 14.3,
            top: (cornertilesize + (index * width)) - 14.2,
            child: Transform.rotate(
              angle: 3 * math.pi / 2,
              child: TileWidget(
                tileIndex: index + 21,
                width: width,
                height: height,
                rotationAngle: math.pi / 2,
              ),
            ),
          );
        }),

        // Top row (horizontal tiles)
        ...List.generate(9, (index) {
          return Positioned(
            left: cornertilesize + (index * width),
            top: 0,
            child: TileWidget(
              tileIndex: index + 11,
              width: width,
              height: height,
              rotationAngle: math.pi / 2,
            ),
          );
        }),

        // Bottom row (horizontal tiles)
        ...List.generate(9, (index) {
          return Positioned(
            right: cornertilesize + (index * width),
            bottom: 0,
            child: TileWidget(
              tileIndex: index + 31,
              width: width,
              height: height,
              rotationAngle: math.pi / -2,
            ),
          );
        }),

        // Corner Tiles
        Positioned(
          left: 0,
          bottom: 0,
          child: TileWidget(
            tileIndex: 0,
            width: cornertilesize,
            height: cornertilesize,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: TileWidget(
            tileIndex: 10,
            width: cornertilesize,
            height: cornertilesize,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: TileWidget(
            tileIndex: 20,
            width: cornertilesize,
            height: cornertilesize,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: TileWidget(
            tileIndex: 30,
            width: cornertilesize,
            height: cornertilesize,
          ),
        ),
      ],
    );
  }
}
