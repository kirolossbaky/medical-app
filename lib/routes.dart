import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/medication_screen.dart';
import 'screens/pharmacy_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/prescriptions_screen.dart';
import 'screens/drug_info_screen.dart';
import 'screens/interactions_screen.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String medications = '/medications';
  static const String pharmacy = '/pharmacy';
  static const String schedule = '/schedule';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String prescriptions = '/prescriptions';
  static const String drugInfo = '/drug-info';
  static const String interactions = '/interactions';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case medications:
        return MaterialPageRoute(builder: (_) => const MedicationScreen());
      case pharmacy:
        return MaterialPageRoute(builder: (_) => const PharmacyScreen());
      case schedule:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case prescriptions:
        return MaterialPageRoute(builder: (_) => const PrescriptionsScreen());
      case drugInfo:
        return MaterialPageRoute(builder: (_) => const DrugInfoScreen());
      case interactions:
        return MaterialPageRoute(builder: (_) => const InteractionsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
