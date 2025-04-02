import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'About Business Game',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 60),
        decoration: _buildGradientBackground(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Game Logo
              SizedBox(
                width: 300,
                height: 120,
                child: Image.asset('assets/images/logo/Logo_widest.PNG'),
              ),
              const SizedBox(height: 20),

              _sectionCard(
                  "Introduction",
                  "Step into the world of strategic business! Buy properties, trade wisely, "
                      "earn profits, and outplay your opponents to become the wealthiest tycoon in the game. "
                      "Luck and skill will determine your fate!"),

              _sectionCard("Game Features", [
                "🎲 Classic business board game experience.",
                "💰 Buy and sell properties strategically.",
                "⚡ Unique chance and club cards for surprises.",
                "🏆 Play with friends."
              ]),

              _sectionCard("How to Play", [
                "🎲 Roll the dice to move around the board.",
                "🏠 Buy properties when you land on unowned ones.",
                "💰 Pay rent if you land on an owned property.",
                "📜 Draw Chance Cards for game-changing effects.",
                "🏆 Win by accumulating the most wealth!"
              ]),

              _sectionCard("Developer Information",
                  ["👨‍💻 Developed by: Aniket Singhal", "🛠 Version: 1.0.0"]),

              _sectionCard("Follow Us", _buildSocialButtons()),
            ],
          ),
        ),
      ),
    );
  }

  // Gradient Background
  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black, Color(0xFF1A1A2E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  // Section Card Widget
  Widget _sectionCard(String title, dynamic content) {
    return Card(
      color: Colors.black.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 10),
            if (content is String)
              Text(
                content,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              )
            else if (content is List<String>)
              Column(
                children: content.map((text) => _bulletPoint(text)).toList(),
              )
          ],
        ),
      ),
    );
  }

  // Bullet Point Widget
  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.grade_outlined, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  // Social Media Buttons
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(Icons.facebook, "https://facebook.com"),
        _socialButton(Icons.sports_esports, "https://discord.com"),
        _socialButton(Icons.web, "https://saniket.vercel.app/"),
      ],
    );
  }

  // Circular Social Media Icon Button
  Widget _socialButton(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          // Implement social media redirection
        },
        borderRadius: BorderRadius.circular(50),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.amber.withOpacity(0.8),
          child: Icon(icon, color: Colors.black, size: 26),
        ),
      ),
    );
  }
}
