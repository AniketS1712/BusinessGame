class TokenPosition {
  static Map<String, double> getPosition(
      int tileIndex, double boardSize, int playerIndex) {
    final double tileWidth = boardSize / 13;
    final double tileHeight = boardSize / 6.5;
    final double cornerTileSize = tileWidth * 2;

    double xPos = 0;
    double yPos = 0;

    // Offset values for each token to avoid overlapping
    final double offsetX = (playerIndex % 2) * 10.0;
    final double offsetY = (playerIndex ~/ 2) * 10.0;

    if (tileIndex == 0) {
      xPos = cornerTileSize / 4 + offsetX; // Bottom-left corner
      yPos = boardSize - cornerTileSize / 2 + offsetY;
    } else if (tileIndex == 10) {
      xPos = cornerTileSize / 4 + offsetX; // Top-left corner
      yPos = cornerTileSize / 4 + offsetY;
    } else if (tileIndex == 20) {
      xPos = boardSize - cornerTileSize / 2 + offsetX; // Top-right corner
      yPos = cornerTileSize / 4 + offsetY;
    } else if (tileIndex == 30) {
      xPos = boardSize - cornerTileSize / 2 + offsetX; // Bottom-right corner
      yPos = boardSize - cornerTileSize / 2 + offsetY;
    } else if (tileIndex > 0 && tileIndex < 10) {
      xPos = 0 + offsetX;
      yPos =
          (boardSize - tileWidth) - ((tileIndex + 1) * tileWidth - 2) + offsetY;
    } else if (tileIndex > 10 && tileIndex < 20) {
      xPos = ((tileIndex + 1) - 10) * tileWidth + 2 + offsetX;
      yPos = tileHeight - 25 + offsetY;
    } else if (tileIndex > 20 && tileIndex < 30) {
      xPos = (boardSize - tileWidth) + 5 + offsetX;
      yPos = ((tileIndex + 1) - 20) * tileWidth + 2 + offsetY;
    } else if (tileIndex > 30 && tileIndex < 40) {
      xPos = (boardSize - tileWidth) -
          ((tileIndex + 1) - 30) * tileWidth +
          2 +
          offsetX;
      yPos = (boardSize - 25) + offsetY;
    }

    return {'x': xPos, 'y': yPos};
  }
}
