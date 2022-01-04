import 'package:flutter/material.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static showSnackbarError(String message) {
    final snackbar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackbar);
  }

  static showSnackbarSuccess(String message) {
    final snackbar = SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackbar);
  }
}
