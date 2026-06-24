import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/view/admin_view.dart';
import '../../features/auth/presentation/views/auth_view.dart';
import '../../features/cart/presentation/view/cart_view.dart';
import '../../features/cart/presentation/view/checkout_view.dart';
import '../../features/designer/presentation/view/designer_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/onboarding/presentation/view/onboarding_screen.dart';
import '../../features/profile/presentation/view/profile_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';
import '../../features/wishlist/presentation/view/wishlist_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Auth flow
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // Main app with bottom nav
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),

    // Full-screen routes
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistView(),
    ),
    GoRoute(
      path: '/designer',
      builder: (context, state) => const DesignerView(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartView()),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: '/admin', builder: (context, state) => const AdminView()),
  ],
);
