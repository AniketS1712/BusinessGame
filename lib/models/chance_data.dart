class Chance {
  final String description;
  final String category;
  final int value;

  Chance(
      {required this.description, required this.category, required this.value});
}

List<Chance> lossCards = [
  Chance(description: "Pay 3000", category: "loss", value: 3000),
  Chance(description: "Pay 2000 in taxes", category: "loss", value: 2000),
  Chance(description: "Lose 1500 due to fees", category: "loss", value: 1500),
];

List<Chance> profitCards = [
  Chance(description: "Earn 3000", category: "profit", value: 3000),
  Chance(description: "Win 2000 in a lottery", category: "profit", value: 2000),
  Chance(
      description: "Earn 1500 from investments",
      category: "profit",
      value: 1500),
];
