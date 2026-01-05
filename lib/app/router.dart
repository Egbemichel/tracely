import 'package:go_router/go_router.dart';

import '../data/dummy.dart';
import '../features/trails/trail_details.dart';
import '../screens/auth/login/login.dart';
import '../screens/auth/signup/signup.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../widgets/screen_wrapper.dart';

final appRouter = GoRouter(
  initialLocation: SplashScreen.path,

  routes: [
    // NON-TAB SCREENS
    GoRoute(
      path: SplashScreen.path,
      name: SplashScreen.routeName,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: OnboardingScreen.path,
      name: OnboardingScreen.routeName,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: LoginScreen.path,
      name: LoginScreen.routeName,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: SignUpScreen.path,
      name: SignUpScreen.routeName,
      builder: (_, __) => const SignUpScreen(),
    ),
    GoRoute(
      path: NotificationsScreen.path,
      name: NotificationsScreen.routeName,
      builder: (_, __) => const NotificationsScreen(),
    ),

    // 🔥 PERSISTENT NAVBAR
    ShellRoute(
      builder: (context, state, child) {
        return ScreenWrapper(child: child);   // Navbar stays here
      },
      routes: [
        GoRoute(
          path: HomeScreen.path,
          name: HomeScreen.routeName,
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: ExploreScreen.path,
          name: ExploreScreen.routeName,
          builder: (_, __) => const ExploreScreen(),
        ),
        GoRoute(
          path: ProfileScreen.path,
          name: ProfileScreen.routeName,
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
    // TRAIL DETAIL OUTSIDE NAVBAR
    GoRoute(
      path: '/trail/:id',
      name: 'trail-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TrailDetailScreen(trailId: id);
      },
    ),
  ],
);
