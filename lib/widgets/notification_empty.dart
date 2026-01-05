import 'package:flutter/material.dart';
import '../app/theme.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100), // Push content down
        // Custom chat bubble illustration
        Container(
          child: (Image.asset(
            'assets/images/message.png',
            width: 264,
            height: 115,
          )),
        ),
        const SizedBox(height: 50),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'No Notifications, yet.',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: TracelyTheme.primary900,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}