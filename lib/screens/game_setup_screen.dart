import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';
import 'package:business_game/screens/gamescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  int _playerCount = 4;
  int _startingMoney = 120000;

  final List<TextEditingController> _nameControllers = [
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
  ];

  final List<Color> _playerColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
  ];

  final List<String> _playerLogos = [
    'assets/images/player1.png',
    'assets/images/player2.png',
    'assets/images/player3.png',
    'assets/images/player4.png',
  ];

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    final List<Player> players = [];
    for (int i = 0; i < _playerCount; i++) {
      final name = _nameControllers[i].text.trim().isEmpty
          ? 'Player ${i + 1}'
          : _nameControllers[i].text.trim();
      players.add(
        Player(
          name: name,
          logoPath: _playerLogos[i],
          color: _playerColors[i],
          money: _startingMoney,
        ),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => GameController(players),
          child: const GameScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Game Setup',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/mainmenu_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withAlpha(160),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Number of Players",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [2, 3, 4].map((count) {
                      final isSelected = _playerCount == count;
                      return ChoiceChip(
                        label: Text(
                          '$count Players',
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.teal.shade900.withAlpha(180),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _playerCount = count;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Starting Money",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [100000, 120000, 150000].map((amount) {
                      final isSelected = _startingMoney == amount;
                      return ChoiceChip(
                        label: Text(
                          '₹${amount ~/ 1000}k',
                          style: TextStyle(
                            fontSize: 15,
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.teal.shade900.withAlpha(180),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _startingMoney = amount;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Player Names",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(_playerCount, (index) {
                    return Card(
                      color: Colors.black.withAlpha(180),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: _playerColors[index], width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: _playerColors[index],
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    AssetImage(_playerLogos[index]),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextField(
                                controller: _nameControllers[index],
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Player ${index + 1} Name',
                                  labelStyle:
                                      const TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _startGame,
                      icon: const Icon(Icons.play_arrow,
                          size: 28, color: Colors.white),
                      label: const Text(
                        "Start Game",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
