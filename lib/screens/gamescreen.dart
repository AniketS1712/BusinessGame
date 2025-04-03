import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/ui/business_board.dart';
import 'package:business_game/ui/player_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            _buildGradientBackground(),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 600;
                bool isTallScreen = constraints.maxHeight > 700;

                return isWideScreen
                    ? _buildWideScreenLayout(gameController)
                    : _buildPortraitLayout(gameController, isTallScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade200,
            Colors.green.shade100,
            Colors.amber.shade100,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
      GameController gameController, bool isTallScreen) {
    return Column(
      children: [
        Expanded(
          flex: isTallScreen ? 5 : 4,
          child: BusinessBoard(players: gameController.players),
        ),
        Expanded(
          flex: isTallScreen ? 2 : 3,
          child: _buildPlayerArea(gameController),
        ),
      ],
    );
  }

  Widget _buildWideScreenLayout(GameController gameController) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: BusinessBoard(players: gameController.players),
        ),
        Expanded(
          flex: 3,
          child: _buildPlayerArea(gameController),
        ),
      ],
    );
  }

  Widget _buildPlayerArea(GameController gameController) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withAlpha(70)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxHeight < 200
                ? SingleChildScrollView(
                    child: PlayerArea(players: gameController.players))
                : PlayerArea(players: gameController.players);
          },
        ),
      ),
    );
  }
}
