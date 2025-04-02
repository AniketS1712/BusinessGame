import 'package:business_game/models/tile_data.dart';
import 'package:business_game/special_tiles/club_interface.dart';
import 'package:flutter/material.dart';
import '../models/player.dart';

class GameController extends ChangeNotifier {
  bool isClubDialogOpen = false;
  final List<Player> players;
  int currentPlayerIndex = 0;
  int dice1 = 1;
  int dice2 = 1;
  List<Player> playersInJail = [];

  GameController(this.players);

  // Move player to the next tile
  void movePlayer(int diceRoll) {
    while (playersInJail.contains(players[currentPlayerIndex])) {
      playersInJail.remove(players[currentPlayerIndex]);
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    }
    final currentPlayer = players[currentPlayerIndex];
    currentPlayer.currentTileIndex =
        (currentPlayer.currentTileIndex + diceRoll) % 40;
    currentPlayer.hasMoved = true;
    currentPlayer.hasPaidRent = false;
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    notifyListeners();
  }

  //Let player buy a property
  void buyProperty(Player player, TileData tile) {
    for (var p in players) {
      if (p.properties.contains(tile)) {
        return;
      }
    }
    if (player.money >= tile.price) {
      updatePlayerMoney(player, -tile.price);
      player.properties.add(tile);
      notifyListeners();
    }
  }

  //Have player pay rent
  void payRent(Player tenant, Player owner, TileData tile) {
    int rentAmount = tile.rent;
    if (tenant.hasPaidRent) return;
    if (tenant.money >= rentAmount) {
      tenant.money -= rentAmount;
      owner.money += rentAmount;
      tenant.hasPaidRent = true;
      notifyListeners();
    }
  }

  //Update dice values used in business board
  void updateDiceValues(int newDice1, int newDice2) {
    dice1 = newDice1;
    dice2 = newDice2;
    notifyListeners();
  }

  //Update player money used in chance functionality
  void updatePlayerMoney(Player player, int amount) {
    int index = players.indexWhere((p) => p.name == player.name);
    if (index != -1) {
      players[index].money += amount;
      notifyListeners();
    }
  }

  void handleJail(Player player, bool isFree) {
    if (!isFree) {
      playersInJail.add(player);
    } else {
      playersInJail.remove(player);
    }
  }

  //Handle player money when they land on a club tile
  void handleClubTile(
      Player currentPlayer, BuildContext context, int betAmount) {
    int totalPot = betAmount * players.length;
    for (var player in players) {
      if (player.money >= betAmount) {
        updatePlayerMoney(player, -betAmount);
      } else {
        player.money = 0;
      }
    }
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showClubDiceRollingDialog(context, players, totalPot, this);
    });
  }
}
