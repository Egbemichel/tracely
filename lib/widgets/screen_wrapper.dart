import 'package:flutter/material.dart';
import '../widgets/navbar.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;

  const ScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const CustomBottomNavbar(),
    );
  }
}
