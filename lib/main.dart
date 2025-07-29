import 'package:cosmo/presentation/screens/home_screen.dart';
import 'package:cosmo/presentation/widgets/theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PlanetApp());
}

class PlanetApp extends StatelessWidget {
  const PlanetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planet app',
      theme: AppTheme.themeSetUp,
      home: HomeScreen(),
    );
  }
}
