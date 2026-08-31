import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String name = 'Player';
  String profilePicUrl = 'assets/images/avatar/avatar1.jpg';
  int totalGamesPlayed = 0;
  int totalGamesWon = 0;
  bool _isLoading = true;

  final List<String> availableAvatars = [
    'assets/images/avatar/avatar1.jpg',
    'assets/images/avatar/avatar2.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('player_name') ?? 'Player';
      profilePicUrl = prefs.getString('player_avatar') ?? availableAvatars.first;
      totalGamesPlayed = prefs.getInt('total_games_played') ?? 0;
      totalGamesWon = prefs.getInt('total_games_won') ?? 0;
      _isLoading = false;
    });
  }

  Future<void> _saveName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_name', newName);
    setState(() {
      name = newName;
    });
  }

  Future<void> _updateProfilePic(String avatar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_avatar', avatar);
    setState(() {
      profilePicUrl = avatar;
    });
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter display name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _saveName(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAvatarSelectionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.black87,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: availableAvatars.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _updateProfilePic(availableAvatars[index]);
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(availableAvatars[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: _buildGradientBackground(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxHeight > 650
                  ? _buildFixedLayout()
                  : _buildScrollableLayout();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFixedLayout() {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildProfileCard(),
        const SizedBox(height: 20),
        _buildGameStats(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildLargeAvatar(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildScrollableLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileCard(),
          const SizedBox(height: 20),
          _buildGameStats(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildLargeAvatar(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black, Color(0xFF1A1A2E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 6,
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showAvatarSelectionSheet,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(200),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePicUrl.isNotEmpty
                          ? AssetImage(profilePicUrl)
                          : null,
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                  onPressed: _showEditNameDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGameStat(
              "Games Played", totalGamesPlayed, Icons.videogame_asset),
          _buildGameStat("Games Won", totalGamesWon, Icons.emoji_events),
        ],
      ),
    );
  }

  Widget _buildGameStat(String title, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 30),
        const SizedBox(height: 6),
        Text(value.toString(),
            style: const TextStyle(fontSize: 22, color: Colors.white)),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLargeAvatar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: profilePicUrl.isNotEmpty
            ? DecorationImage(
                image: AssetImage(profilePicUrl),
                fit: BoxFit.contain,
              )
            : null,
      ),
    );
  }
}
