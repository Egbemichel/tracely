import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = "profile";
  static const String path = "/profile";


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile'),
    );
  }
}
