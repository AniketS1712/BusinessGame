import 'package:business_game/controllers/audio_service.dart';
import 'package:business_game/firebase_options.dart';
import 'package:business_game/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:business_game/controllers/game_controller.dart';
import 'package:business_game/models/player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioService.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!AudioService.isMuted) {
    AudioService.play('audio/themeSong.mp3');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Player> players = [
      Player(
        name: 'Player 1',
        logoPath: 'assets/images/player1.png',
        color: Colors.red,
        money: 120000,
      ),
      Player(
        name: 'Player 2',
        logoPath: 'assets/images/player2.png',
        color: Colors.blue,
        money: 120000,
      ),
      Player(
        name: 'Player 3',
        logoPath: 'assets/images/player3.png',
        color: Colors.green,
        money: 120000,
      ),
      Player(
        name: 'Player 4',
        logoPath: 'assets/images/player4.png',
        color: Colors.purple,
        money: 120000,
      ),
    ];

    return ChangeNotifierProvider(
      create: (_) => GameController(players),
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
