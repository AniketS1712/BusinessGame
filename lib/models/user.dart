class User {
  final String uid;
  final String name;
  final String profilePic;
  final String gender;
  int totalGamesPlayed;
  int totalGamesWon;

  User({  
    required this.name,
    required this.profilePic,
    required this.gender,
    required this.uid,
    this.totalGamesPlayed = 0,
    this.totalGamesWon = 0,
  });
}
