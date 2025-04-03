import 'package:business_game/screens/gamescreen.dart';
import 'package:business_game/screens/about.dart';
import 'package:business_game/screens/profile.dart';
import 'package:business_game/screens/settings.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mainmenu_background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
              child: Row(
                children: [
                  _iconButton(Icons.person, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  }),
                  const Spacer(),
                  _iconButton(Icons.message_outlined, () {}),
                  _iconButton(Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  }),
                ],
              ),
            ),

            // Logo Section
            SizedBox(
              width: 380,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo/Logo_widest.PNG',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Spacer(),

            // Buttons Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth >
                        600; // Adjust breakpoint as needed

                    return isWide
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _menuButton("Play", Icons.play_arrow, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GameScreen()));
                              }),
                              const SizedBox(width: 20),
                              _menuButton("Friends", Icons.group, () {}),
                              const SizedBox(width: 20),
                              _menuButton("About", Icons.info_outline, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const About()),
                                );
                              }),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _menuButton("Play", Icons.play_arrow, () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GameScreen()));
                              }),
                              _menuButton("Friends", Icons.group, () {}),
                              _menuButton("About", Icons.info_outline, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const About()),
                                );
                              }),
                            ],
                          );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _menuButton(String text, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 180,
        child: ElevatedButton.icon(
          icon: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
          label: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade900,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Colors.white.withAlpha(200),
                width: 1,
              ),
            ),
            elevation: 6,
            shadowColor: Colors.white,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 30),
      onPressed: onPressed,
    );
  }
}
