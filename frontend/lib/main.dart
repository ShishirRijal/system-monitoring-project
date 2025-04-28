import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:system_monitoring_project/providers/system_data_provider.dart';
import 'package:system_monitoring_project/screens/alert_page.dart';
import 'package:system_monitoring_project/screens/dashboard_page.dart';
import 'package:system_monitoring_project/screens/landing_page.dart';
import 'package:system_monitoring_project/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SystemDataProvider())],
      child: const SystemMonitorApp(),
    ),
  );
}

class SystemMonitorApp extends StatelessWidget {
  const SystemMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroSys Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.rubikTextTheme(),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.rubikTextTheme(),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/alerts': (context) => const AlertsPage(),
      },
    );
  }
}
