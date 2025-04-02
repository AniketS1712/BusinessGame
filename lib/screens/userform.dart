import 'package:business_game/screens/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _submitForm() async {
    String name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty")),
      );
      return;
    }

    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the user's Firestore document
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
          "name": name,
          "hasCompletedForm": true, // Mark that the form is complete
        });

        // Navigate to the main menu after the form is filled out
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenu()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Enter your name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
