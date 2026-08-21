import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/reviews/review_screen.dart';
import 'screens/promotions/promo_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'user/main_page.dart';
import 'utils/app_colors.dart';
import 'services/database_init.dart' as db_init;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory based on platform
  // Desktop: uses sqflite_common_ffi (FFI initialization)
  // Web: uses no-op initialization (sqflite not supported on web)
  // Mobile: uses platform-specific sqflite (handled by sqflite package)
  try {
    if (!kIsWeb) {
      await db_init.initDatabaseFactory();
    }
  } catch (e) {
    print('Database initialization skipped: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FASTBITES Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          brightness: Brightness.light,
        ),
        textTheme: _notoWithFallback(Theme.of(context).textTheme),
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/reviews': (context) => const ReviewScreen(),
        '/promos': (context) => const PromoScreen(),
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
        '/user_main': (context) => const MainPage(),
      },
    );
  }
}

TextTheme _notoWithFallback(TextTheme base) {
  // Start with Google Fonts Noto Sans applied to the existing theme
  final g = GoogleFonts.notoSansTextTheme(base);

  TextStyle? withFallback(TextStyle? s) {
    if (s == null) return null;
    return s.copyWith(
      // prefer system Roboto as a common fallback and a generic emoji font
      fontFamilyFallback: const [
        'Roboto',
        'Noto Color Emoji',
        'Segoe UI Emoji',
      ],
    );
  }

  return TextTheme(
    displayLarge: withFallback(g.displayLarge),
    displayMedium: withFallback(g.displayMedium),
    displaySmall: withFallback(g.displaySmall),
    headlineLarge: withFallback(g.headlineLarge),
    headlineMedium: withFallback(g.headlineMedium),
    headlineSmall: withFallback(g.headlineSmall),
    titleLarge: withFallback(g.titleLarge),
    titleMedium: withFallback(g.titleMedium),
    titleSmall: withFallback(g.titleSmall),
    bodyLarge: withFallback(g.bodyLarge),
    bodyMedium: withFallback(g.bodyMedium),
    bodySmall: withFallback(g.bodySmall),
    labelLarge: withFallback(g.labelLarge),
    labelMedium: withFallback(g.labelMedium),
    labelSmall: withFallback(g.labelSmall),
  );
}
