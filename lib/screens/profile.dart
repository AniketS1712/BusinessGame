import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  String name = '';
  String profilePicUrl = '';
  String gender = "";
  int totalGamesPlayed = 0;
  int totalGamesWon = 0;
  // ignore: unused_field
  bool _isLoading = true;

  final List<String> availableAvatars = [
    'assets/images/avatar/avatar1.jpg',
    'assets/images/avatar/avatar2.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    if (uid.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'];
          profilePicUrl = userDoc['avatar'] ?? '';
          gender = userDoc['gender'] ?? '';
          totalGamesPlayed = userDoc['totalGamesPlayed'] ?? 0;
          totalGamesWon = userDoc['totalGamesWon'] ?? 0;
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
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

  Future<void> _updateProfilePic(String avatar) async {
    if (uid.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'avatar ': avatar,
      });

      setState(() {
        profilePicUrl = avatar; // Update immediately in UI
      });
    } catch (e) {
      debugPrint("Error updating profile picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
        Expanded(
          // This replaces Spacer() for better dynamic spacing
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildLargeAvatar(),
          ),
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

  // 🔹 Gradient Background
  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black, Color(0xFF1A1A2E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  // 🔹 Profile Card
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
            // Profile Picture with Edit Button
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

            // Name
            Text(
              name,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),

            // Gender
            Text(
              "Gender: $gender",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            // UID (Copyable)
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: uid));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("UID copied to clipboard!")),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "UID: $uid",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.copy, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Game Stats Section
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
    return Flexible(
      child: Container(
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
      ),
    );
  }
}
