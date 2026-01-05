import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../app/theme.dart';
import '../data/dummy.dart'; // <-- import to access getUnreadCount()
import '../screens/auth/login/login.dart';
import '../screens/notifications/notification_screen.dart';
import '../services/auth_service.dart';

class WelcomeHeader extends StatelessWidget {
  final String userName;
  const WelcomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // 🔥 Pull unread count from dummy data
    final unread = getUnreadCount();
    final hasUnread = unread > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Text(
            "Welcome, $userName",
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "PlusJakartaSans",
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: <Widget>[
            _buildIconButton(
              onPressed: () async {
                final result = await context.push<bool>(NotificationsScreen.path);

                // result == true  → all read
                if (result == true) {
                  // trigger UI rebuild
                  (context as Element).markNeedsBuild();
                }
              },
              icon: IconsaxPlusLinear.notification,
              showDot: getUnreadCount() > 0, // 🔥 dynamically controlled
            ),
            const SizedBox(width: 10),
          ],
        )
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool showDot = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.black, size: 24),
            splashColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
        ),

        if (showDot)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: TracelyTheme.secondary500,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
