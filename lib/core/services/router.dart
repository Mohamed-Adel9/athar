import 'package:athar/features/home/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/views/auth_view.dart';
import '../../features/onboarding/presentation/view/onboarding_screen.dart';
import '../../features/splash/presentation/view/splash_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // Shell route for screens with bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => Scaffold(body: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        // GoRoute(
        //   path: '/wishlist',
        //   // builder: (context, state) => const WishlistScreen(),
        // ),
        // GoRoute(
        //   path: '/designer',
        //   // builder: (context, state) => const DesignerScreen(),
        // ),
        // GoRoute(
        //   path: '/cart',
        //   // builder: (context, state) => const CartScreen(),
        // ),
        // GoRoute(
        //   path: '/profile',
        //   // builder: (context, state) => const ProfileScreen(),
        // ),
      ],
    ),
    // Full-screen routes (no bottom nav)
    // GoRoute(
    //   path: '/product/:id',
    //   // builder: (context, state) => ProductDetailScreen(
    //   //   productId: state.pathParameters['id']!,
    //   // ),
    // ),
    // GoRoute(
    //   path: '/checkout',
    //   // builder: (context, state) => const CheckoutScreen(),
    // ),
    // GoRoute(
    //   path: '/wallet',
    //   // builder: (context, state) => const WalletScreen(),
    // ),
    // GoRoute(
    //   path: '/orders',
    //   // builder: (context, state) => const OrdersScreen(),
    // ),
    // GoRoute(
    //   path: '/notifications',
    //   // builder: (context, state) => const NotificationsScreen(),
    // ),
  ],
);
