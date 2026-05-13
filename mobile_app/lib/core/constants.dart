import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'core/constants.dart';
import 'services/auth_service.dart';
import 'viewmodels/camera_provider.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: AegisAIApp()));
}

class AegisAIApp extends ConsumerWidget {
  const AegisAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return MaterialApp(
      title: 'Aegis AI System',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: authService.isLoggedIn ? const DashboardScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

class AppConstants {
  // TODO: Thay IP này bằng IPv4 của máy tính bạn (ví dụ: 192.168.1.x)
  // Nếu dùng máy ảo Android (Emulator), dùng: 10.0.2.2
  // Nếu dùng iOS Simulator hoặc test trực tiếp trên Web, dùng: 127.0.0.1
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1'; 
  
  static const String appName = 'Aegis Vision';
}