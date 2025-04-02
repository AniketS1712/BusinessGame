import 'package:business_game/controllers/authservice.dart';
import 'package:business_game/screens/main_menu.dart';
import 'package:business_game/screens/userform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoggingIn = false;
  bool _isCheckingAuth = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _navigateToMainMenu();
    } else {
      setState(() => _isCheckingAuth = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/login_background.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withAlpha(130),
          ),

          // Login Content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Center(
              child: _isCheckingAuth
                  ? const CircularProgressIndicator(color: Colors.white)
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Game Logo
                          Image.asset(
                            "assets/images/logo/Logo_widest.PNG",
                            height: 100,
                          ),
                          const Spacer(),

                          if (_isLoggingIn)
                            const CircularProgressIndicator(color: Colors.white)
                          else
                            Column(
                              children: [
                                // Google Login Button
                                _buildLoginButton(
                                  text: "Login with Google",
                                  icon: Icons.login,
                                  color: Colors.redAccent,
                                  onPressed: _signInWithGoogle,
                                ),
                                const SizedBox(height: 20),

                                // Guest Login Button
                                _buildLoginButton(
                                  text: "Login as Guest",
                                  icon: Icons.person_outline,
                                  color: Colors.blueGrey,
                                  onPressed: _signInAsGuest,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          shadowColor: Colors.black54,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoggingIn = true);
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        _navigateToNextScreen(user);
      } else {
        _showError("Login failed. Please try again.");
      }
    } catch (e) {
      _showError("An error occurred: ${e.toString()}");
    } finally {
      setState(() => _isLoggingIn = false);
    }
  }

  Future<void> _signInAsGuest() async {
    setState(() => _isLoggingIn = true);
    try {
      User? user = await _authService.signInAnonymously();
      if (user != null) {
        _navigateToNextScreen(user);
      } else {
        _showError("Guest login failed. Please try again.");
      }
    } catch (e) {
      _showError("An error occurred: ${e.toString()}");
    } finally {
      setState(() => _isLoggingIn = false);
    }
  }

  Future<void> _navigateToNextScreen(User user) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      bool hasCompletedForm = false;

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>?;
        hasCompletedForm = userData?["hasCompletedForm"] ?? false;
      }

      if (mounted) {
        setState(() {});

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasCompletedForm) {
            _navigateToMainMenu();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserForm()),
            );
          }
        });
      }
    } catch (e) {
      _showError("Firestore error: ${e.toString()}");
    }
  }

  void _navigateToMainMenu() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainMenu()),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
