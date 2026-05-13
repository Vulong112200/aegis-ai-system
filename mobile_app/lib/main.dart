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
      debugShowCheckedModeBanner: false, // Tắt chữ DEBUG xấu xí ở góc
      theme: AegisTheme.darkTheme,
      
      // Kéo màn nhung lên, hiển thị Dashboard thực sự!
      home: const DashboardScreen(), 
    );
  }
}