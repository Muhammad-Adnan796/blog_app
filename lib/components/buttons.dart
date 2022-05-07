import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  CustomButton({required this.title, required this.onPress});


  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: Colors.cyan,
        minWidth: double.infinity,
        onPressed: onPress,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
