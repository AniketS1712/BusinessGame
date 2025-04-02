import 'package:business_game/models/tile_data.dart';
import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  final String name;
  final String logoPath;
  final Color color;
  int money;
  int position;
  List<TileData> properties;
  int currentTileIndex;
  bool hasMoved = false;
  bool isInJail = false;
  bool hasPaidRent = false;
  int jailTurns = 0;

  Player({
    required this.name,
    required this.logoPath,
    required this.color,
    this.money = 120000,
    this.position = 0,
    this.currentTileIndex = 0,
  }) : properties = [];
}
