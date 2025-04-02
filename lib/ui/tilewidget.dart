import 'package:flutter/material.dart';
import '../models/tile_data.dart';

class TileWidget extends StatelessWidget {
  final int tileIndex;
  final double width;
  final double height;
  final double rotationAngle;

  const TileWidget({
    super.key,
    required this.tileIndex,
    required this.width,
    required this.height,
    this.rotationAngle = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tile = tiles[tileIndex];

    final bool isSpecialTile = tile.type == TileType.incometax ||
        tile.type == TileType.chance ||
        tile.type == TileType.wealthtax;

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        margin: const EdgeInsets.all(0.1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(3),
          gradient: LinearGradient(
            colors: [
              tile.color.withAlpha(250),
              tile.color.withAlpha(240),
              tile.color.withAlpha(230),
              tile.color.withAlpha(240),
              tile.color.withAlpha(220),
              tile.color.withAlpha(210),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isSpecialTile
            ? ClipRRect(
                child: Image.asset(
                  tile.image!,
                  fit: BoxFit.cover,
                ),
              )
            : Transform.rotate(
                angle: rotationAngle,
                child: tile.image != null
                    ? ClipRRect(
                        child: Image.asset(
                          tile.image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Price Section
                          if (tile.price > 0)
                            Container(
                              height: width / 3,
                              alignment: Alignment.center,
                              child: Text(
                                '₹${tile.price}',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          // Label Section
                          Container(
                            height: width / 3,
                            alignment: Alignment.center,
                            child: Text(
                              tile.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 6,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
