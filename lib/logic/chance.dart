import 'dart:math';
import 'package:business_game/models/chance_data.dart';

Chance getRandomCard(List<Chance> cards) {
  final random = Random();
  return cards[random.nextInt(cards.length)];
}

List<Chance> getRandomChances() {
  final random = Random();

  List<Chance> selectedCards = [
    getRandomCard(lossCards),
    getRandomCard(profitCards),
  ];

  selectedCards.shuffle(random);

  return selectedCards;
}
