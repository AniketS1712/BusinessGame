import 'package:business_game/special_tiles/club_interface.dart';
import 'package:business_game/special_tiles/jail_interface.dart';
import 'package:flutter/material.dart';
import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/controllers/token_position.dart';
import 'package:business_game/models/player.dart';
import 'package:business_game/models/tile_data.dart';
import 'package:business_game/ui/property_details_interface.dart';
import 'package:business_game/special_tiles/chance_interface.dart';

class PlayerToken extends StatelessWidget {
  final List<Player> players;
  final double size;
  final double boardSize;
  final int currentPlayerIndex;
  final GameController gameController;
  final int dice1;
  final int dice2;

  const PlayerToken({
    super.key,
    required this.players,
    this.size = 12,
    required this.boardSize,
    required this.currentPlayerIndex,
    required this.gameController,
    required this.dice1,
    required this.dice2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: players
          .asMap()
          .map((index, player) {
            final mappedIndex = (index + 1) % 4;
            final position = TokenPosition.getPosition(
                player.currentTileIndex, boardSize, index);

            if (mappedIndex == currentPlayerIndex) {
              handleTileAction(
                  context, player, dice1, dice2, boardSize, gameController);
            }

            return MapEntry(
                index,
                Positioned(
                  left: position['x']!,
                  top: position['y']!,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: player.color,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ));
          })
          .values
          .toList(),
    );
  }
}

void handleTileAction(BuildContext context, Player player, int dice1, int dice2,
    double boardSize, GameController gameController) {
  TileData tile = TileData.getTileByIndex(player.currentTileIndex);

  if (gameController.playersInJail.contains(player)) {
    return;
  }

  switch (tile.type) {
    case TileType.start:
      if (player.hasMoved) {
        gameController.updatePlayerMoney(player, 5000);
      }
      break;
    case TileType.incometax:
      gameController.updatePlayerMoney(player, -1000);
      break;
    case TileType.wealthtax:
      gameController.updatePlayerMoney(player, -2000);

      break;
    case TileType.chance:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showChanceDialog(context, player);
      });
      break;
      case TileType.resthouse:
      break;
    case TileType.jail:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showJailInterface(context, (bool isFree) {
          gameController.handleJail(player, isFree);
        });
      });
      break;
    case TileType.club:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showClubBetSelectionDialog(context, (selectedAmount) {
          gameController.handleClubTile(player, context, selectedAmount);
        });
      });
      break;
    case TileType.property:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPropertyDetails(context, tile, player, gameController);
      });
      break;
  }
}
