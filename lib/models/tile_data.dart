import 'package:flutter/material.dart';

enum TileType {
  property,
  incometax,
  wealthtax,
  chance,
  start,
  jail,
  resthouse,
  club
}

class TileColors {
  static const List<Color> palette = [
    Color(0xFFF4A261),
    Color(0xFF468FAF),
    Color(0xFFEE6C4D),
    Color(0xFF2A9D8F),
  ];
}

class TileData {
  final String label;
  final TileType type;
  final Color color;
  final int price;
  final int rent;
  final int renthouse1;
  final int renthouse2;
  final int renthouse3;
  final int renthotel;
  final int bankmortrage;
  final String? image;

  TileData({
    required this.label,
    this.type = TileType.property,
    this.color = Colors.black,
    this.price = 0,
    this.rent = 0,
    this.image,
  })  : bankmortrage = (price ~/ 2),
        renthouse1 = (price + (price * 20 ~/ 100)),
        renthouse2 = (price + (price * 40 ~/ 100)),
        renthouse3 = (price + (price * 60 ~/ 100)),
        renthotel = (price * 2);

  static TileData getTileByIndex(int index) {
    return tiles[index];
  }
}

final List<TileData> tiles = [
  // LFT COLUMN
  TileData(
    label: 'Start',
    type: TileType.start,
    image: 'assets/images/tileimages/start.jpg',
  ),
  TileData(
    label: 'Sweden',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 16000,
    rent: 4500,
  ),
  TileData(
    label: 'Kenya',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 18000,
    rent: 5000,
  ),
  TileData(
    label: 'UK',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 15000,
    rent: 4000,
  ),
  TileData(
    label: 'Kerala',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 10000,
    rent: 1500,
  ),
  TileData(
    label: 'IncomeTax',
    type: TileType.incometax,
    image: 'assets/images/tileimages/incometax.jpg',
  ),
  TileData(
    label: 'Morocco',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 10000,
    rent: 1500,
  ),
  TileData(
    label: 'Austria',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 12000,
    rent: 2000,
  ),
  TileData(
    label: 'London',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 14000,
    rent: 3000,
  ),
  TileData(
    label: 'Norway',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 12000,
    rent: 2000,
  ),
  // TOP ROW
  TileData(
    label: 'RestHouse',
    type: TileType.resthouse,
    image: 'assets/images/tileimages/resthouse.jpg',
  ),
  TileData(
    label: 'Berlin',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 13000,
    rent: 2500,
  ),
  TileData(
    label: 'Nepal',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 19000,
    rent: 5500,
  ),
  TileData(
    label: 'Seoul',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 19000,
    rent: 5500,
  ),
  TileData(
    label: 'Spain',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 21000,
    rent: 6500,
  ),
  TileData(
    label: 'Chance',
    type: TileType.chance,
    image: 'assets/images/tileimages/chance1.jpg',
  ),
  TileData(
    label: 'Brazil',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 18000,
    rent: 5000,
  ),
  TileData(
    label: 'Athens',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 11000,
    rent: 1500,
  ),
  TileData(
    label: 'Bangkok',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 12000,
    rent: 2000,
  ),
  TileData(
    label: 'NewYork',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 8000,
    rent: 1000,
  ),
  // RIGHT COLUMN
  TileData(
    label: 'Jail',
    type: TileType.jail,
    image: 'assets/images/tileimages/jail.jpg',
  ),
  TileData(
    label: 'Japan',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 22000,
    rent: 7000,
  ),
  TileData(
    label: 'Lisbon',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 8000,
    rent: 1000,
  ),
  TileData(
    label: 'Egypt',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 21000,
    rent: 6500,
  ),
  TileData(
    label: 'Iceland',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 13000,
    rent: 2500,
  ),
  TileData(
    label: 'Chance',
    type: TileType.chance,
    image: 'assets/images/tileimages/chance2.jpg',
  ),
  TileData(
    label: 'Bali',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 12000,
    rent: 2000,
  ),
  TileData(
    label: 'Paris',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 15000,
    rent: 4000,
  ),
  TileData(
    label: 'China',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 20000,
    rent: 6000,
  ),
  TileData(
    label: 'Mexico',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 11000,
    rent: 1500,
  ),
  // BOTTOM ROW
  TileData(
    label: 'Club',
    type: TileType.club,
    image: 'assets/images/tileimages/club.jpg',
  ),
  TileData(
    label: 'Venice',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 16000,
    rent: 4500,
  ),
  TileData(
    label: 'Vegas',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 15000,
    rent: 4000,
  ),
  TileData(
    label: 'Rome',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 20000,
    rent: 6000,
  ),
  TileData(
    label: 'Tokyo',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 18000,
    rent: 5000,
  ),
  TileData(
    label: 'WealthTax',
    type: TileType.wealthtax,
    image: 'assets/images/tileimages/wealthtax.jpg',
  ),
  TileData(
    label: 'India',
    type: TileType.property,
    color: TileColors.palette[0],
    price: 22000,
    rent: 7000,
  ),
  TileData(
    label: 'Moscow',
    type: TileType.property,
    color: TileColors.palette[1],
    price: 14000,
    rent: 3000,
  ),
  TileData(
    label: 'Chile',
    type: TileType.property,
    color: TileColors.palette[2],
    price: 18000,
    rent: 5000,
  ),
  TileData(
    label: 'Dubai',
    type: TileType.property,
    color: TileColors.palette[3],
    price: 15000,
    rent: 4000,
  ),
];
