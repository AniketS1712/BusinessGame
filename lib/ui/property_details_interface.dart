import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';
import 'package:flutter/material.dart';
import 'package:business_game/models/tile_data.dart';
import 'package:business_game/assets/tile_image_mapping.dart';

class PropertyDetails extends StatelessWidget {
  final TileData tile;
  final Player player;
  final GameController gameController;

  const PropertyDetails({
    super.key,
    required this.tile,
    required this.player,
    required this.gameController,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double cardWidth = screenSize.width * 0.7;
    final double cardHeight = screenSize.height * 0.65;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: tile.color,
        border: Border.all(color: Colors.white38, width: 5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(250),
            blurRadius: 20,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLabel(tile.label),
          _buildUnderline(cardWidth),
          const SizedBox(height: 10),
          _buildPropertyImage(tile.label, cardWidth),
          const SizedBox(height: 10),
          _buildUnderline(cardWidth),
          const SizedBox(height: 10),
          _buildPriceAndRentDetails(tile),
          const Spacer(),
          _buildActionButtons(context),
          _buildUnderline(cardWidth),
          _buildBankMortrage(tile.bankmortrage),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              gameController.buyProperty(player, tile);
              Navigator.pop(context);
            },
            child: const Text('Buy Property'),
          ),
        ],
      ),
    );
  }
}

Widget _buildLabel(String label) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget _buildUnderline(double cardWidth) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Container(
      width: cardWidth,
      height: 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

Widget _buildPropertyImage(String label, double cardWidth) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Container(
      width: cardWidth - 40,
      height: cardWidth - 120,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(getTileImage(label)),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(180),
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPriceAndRentDetails(TileData tile) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tile.price > 0)
          Text(
            'Price: ₹${tile.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        const SizedBox(height: 8),
        if (tile.rent > 0)
          Text(
            'Rent: ₹${tile.rent.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent,
            ),
          ),
        Text(
          'One House Rent: ₹${tile.renthouse1.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        ),
        Text(
          'Two House Rent: ₹${tile.renthouse2.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        ),
        Text(
          'Three House Rent: ₹${tile.renthouse3.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        ),
        Text(
          'Hotel Rent: ₹${tile.renthotel.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
          ),
        ),
      ],
    ),
  );
}

Widget _buildBankMortrage(int bankmortrage) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Center(
      child: Text(
        'Bank mortrage value of this card is: $bankmortrage',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

void showPropertyDetails(BuildContext context, TileData tile, Player player,
    GameController gameController) {
  Player? owner;
  for (var p in gameController.players) {
    if (p.properties.contains(tile)) {
      owner = p;
      break;
    }
  }

  if (owner != null) {
    gameController.payRent(player, owner, tile);
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: PropertyDetails(
          tile: tile,
          player: player,
          gameController: gameController,
        ),
      );
    },
  );
}
