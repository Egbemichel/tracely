import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../app/theme.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({super.key});

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(HomeScreen.path)) return 0;
    if (location.startsWith(ExploreScreen.path)) return 1;
    if (location.startsWith(ProfileScreen.path)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget buildItem({
      required IconData icon,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: selected
            ? Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: TracelyTheme.secondary500,
          ),
          child: Icon(icon, size: 30, color: TracelyTheme.neutral0),
        )
            : Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 32, color: TracelyTheme.neutral0),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: bottomPadding + 12,
        top: 12,
        left: 20,
        right: 20,
      ),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: TracelyTheme.neutral600,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildItem(
              icon: IconsaxPlusBold.home_1,
              selected: selectedIndex == 0,
              onTap: () => context.goNamed(HomeScreen.routeName),
            ),
            buildItem(
              icon: IconsaxPlusBold.global_search,
              selected: selectedIndex == 1,
              onTap: () => context.goNamed(ExploreScreen.routeName),
            ),
            buildItem(
              icon: IconsaxPlusBold.profile_circle,
              selected: selectedIndex == 2,
              onTap: () => context.goNamed(ProfileScreen.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
