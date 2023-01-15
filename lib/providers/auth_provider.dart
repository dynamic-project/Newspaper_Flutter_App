import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screen/login_page.dart';
import '../screen/news_list_page.dart';

class AuthProvider {
  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      var authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // check if the user is authenticated
      if (authResult.user != null) {
        // navigate to the NewsList screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NewsListPage()));
      }
    } catch (e) {
      // handle error
      // Get the error message
      var errorMessage = e.toString();
      // Showing an error message using an AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("User not found"),
            content: const Text("There is no user record corresponding to this identifier. The user may have been deleted."),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> signUp(String email, String password, BuildContext context) async {
    try {
      var authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // check if the user is authenticated
      if (authResult.user != null) {
        // navigate to the LoginPage screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } catch (e) {
      // handle error
      // Get the error message
      var errorMessage = e.toString();
      // Showing an error message using an AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Sign Up error"),
            content: Text(errorMessage),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}