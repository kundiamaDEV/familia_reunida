import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/authentication/presentation/screens/register_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/welcome/presentation/screens/welcome_screen.dart';
import '../features/authentication/presentation/screens/verify_contact_screen.dart';
import '../features/family/presentation/screens/family_setup_screen.dart';
import '../features/family/presentation/screens/create_family_screen.dart';

class FamiliaReunidaApp extends StatelessWidget {
  const FamiliaReunidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Família Reunida',
      theme: AppTheme.light,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        WelcomeScreen.routeName: (_) => const WelcomeScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        FamilySetupScreen.routeName: (_) => const FamilySetupScreen(),
        CreateFamilyScreen.routeName: (_) => const CreateFamilyScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == VerifyContactScreen.routeName) {
          final phoneNumber = settings.arguments as String? ?? '';

          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => VerifyContactScreen(phoneNumber: phoneNumber),
          );
        }

        return null;
      },
    );
  }
}
