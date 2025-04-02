import 'package:business_game/controllers/audio_service.dart';
import 'package:business_game/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  double _volume = 1.0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _loadAudioSettings();
  }

  /// Load audio settings from SharedPreferences
  Future<void> _loadAudioSettings() async {
    await AudioService.init(); // Ensure values are loaded
    setState(() {
      _volume = AudioService.volume;
      _isMuted = AudioService.isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCard(
                icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                title: "Mute Sounds",
                trailing: Switch(
                  value: _isMuted,
                  onChanged: (value) async {
                    setState(() {
                      _isMuted = value;
                    });
                    await AudioService.toggleMute(); // Save the mute setting
                  },
                ),
              ),
              // Volume Slider Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sound Volume",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        value: _volume,
                        min: 0,
                        max: 1,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) async {
                          setState(() {
                            _volume = value;
                          });
                          await AudioService.setVolume(_volume); // Save volume
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildCard(
                icon: Icons.restore,
                title: "Reset Game Progress",
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: _resetGameProgress,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon,
      required String title,
      required Widget trailing}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        trailing: trailing,
      ),
    );
  }

  void _resetGameProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Game Progress"),
        content: const Text(
            "Are you sure you want to reset all progress? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Game progress reset!")),
              );
            },
            child: const Text("Reset", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }
}
