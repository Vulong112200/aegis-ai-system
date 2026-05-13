import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'presentation/screens/dashboard_screen.dart';

void main() {
  runApp(
    // ProviderScope is mandatory for Riverpod
    const ProviderScope(
      child: AegisApp(),
    ),
  );
}

class AegisApp extends StatelessWidget {
  const AegisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aegis Vision',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Aegis System Ready', style: TextStyle(color: Colors.white)),
        ),
      ),
      // TODO: home: const DashboardScreen(),
    );
  }
}