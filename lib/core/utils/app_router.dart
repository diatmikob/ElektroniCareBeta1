import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/user_type_selection_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/history/presentation/pages/repair_detail_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/services/presentation/pages/service_detail_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/technician/pages/technician_dashboard_page.dart';
import '../../features/technician/pages/technician_requests_page.dart';
import '../../shared/widgets/main_navigation.dart';
import '../services/firebase_service.dart';

// Route names
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String userTypeSelection = '/user-type-selection';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String services = '/services';
  static const String serviceDetail = '/service-detail';
  static const String history = '/history';
  static const String repairDetail = '/repair-detail';
  static const String booking = '/booking';
  static const String notifications = '/notifications';
  
  // Technician routes
  static const String technicianDashboard = '/technician/dashboard';
  static const String technicianRequests = '/technician/requests';
}

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final user = FirebaseService.currentUser;
      final isLoggedIn = user != null;
      
      // List of routes that require authentication
      final protectedRoutes = [
        AppRoutes.dashboard,
        AppRoutes.profile,
        AppRoutes.editProfile,
        AppRoutes.services,
        AppRoutes.serviceDetail,
        AppRoutes.history,
        AppRoutes.repairDetail,
        AppRoutes.booking,
        AppRoutes.notifications,
        AppRoutes.technicianDashboard,
        AppRoutes.technicianRequests,
      ];
      
      // List of auth routes
      final authRoutes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
      ];
      
      final currentPath = state.uri.path;
      
      // If user is not logged in and trying to access protected route
      if (!isLoggedIn && protectedRoutes.contains(currentPath)) {
        return AppRoutes.login;
      }
      
      // If user is logged in and trying to access auth routes
      if (isLoggedIn && authRoutes.contains(currentPath)) {
        return AppRoutes.userTypeSelection;
      }
      
      return null; // No redirect needed
    },
    routes: [
      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.userTypeSelection,
        name: 'user-type-selection',
        builder: (context, state) => const UserTypeSelectionPage(),
      ),
      
      // Main App Routes with Shell
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          // Dashboard
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          
          // Services
          GoRoute(
            path: AppRoutes.services,
            name: 'services',
            builder: (context, state) => const ServicesPage(),
          ),
          
          // History
          GoRoute(
            path: AppRoutes.history,
            name: 'history',
            builder: (context, state) => const HistoryPage(),
          ),
          
          // Profile
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      
      // Standalone Routes (without bottom navigation)
      GoRoute(
        path: AppRoutes.serviceDetail,
        name: 'service-detail',
        builder: (context, state) {
          final serviceId = state.uri.queryParameters['id'] ?? '';
          return ServiceDetailPage(serviceId: serviceId);
        },
      ),
      GoRoute(
        path: AppRoutes.repairDetail,
        name: 'repair-detail',
        builder: (context, state) {
          final repairId = state.uri.queryParameters['id'] ?? '';
          return RepairDetailPage(repairId: repairId);
        },
      ),
      GoRoute(
        path: AppRoutes.booking,
        name: 'booking',
        builder: (context, state) {
          final serviceId = state.uri.queryParameters['serviceId'];
          return BookingPage(serviceId: serviceId);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      
      // Technician Routes
      GoRoute(
        path: AppRoutes.technicianDashboard,
        name: 'technician-dashboard',
        builder: (context, state) => const TechnicianDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.technicianRequests,
        name: 'technician-requests',
        builder: (context, state) => const TechnicianRequestsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Navigation helper extension
extension AppRouterExtension on BuildContext {
  void pushNamed(String name, {Map<String, String>? queryParameters}) {
    go(name, extra: queryParameters);
  }
  
  void pushReplacementNamed(String name, {Map<String, String>? queryParameters}) {
    pushReplacement(name, extra: queryParameters);
  }
}