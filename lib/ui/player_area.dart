import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerArea extends StatelessWidget {
  final List<Player> players;

  const PlayerArea({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 3,
        ),
        itemCount: players.length,
        itemBuilder: (context, index) {
          return Consumer<GameController>(
            builder: (context, gameController, child) {
              return PlayerCard(player: gameController.players[index]);
            },
          );
        },
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 0, 0, 0).withAlpha(255),
            const Color.fromARGB(255, 0, 0, 0).withAlpha(200),
            const Color.fromARGB(255, 0, 0, 0).withAlpha(245),
            const Color.fromARGB(255, 0, 0, 0).withAlpha(235),
            const Color.fromARGB(255, 0, 0, 0).withAlpha(220),
            const Color.fromARGB(255, 0, 0, 0).withAlpha(225),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: player.color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(player.logoPath),
            radius: 20,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                "₹${player.money.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerProperty extends StatelessWidget {
  const PlayerProperty({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
