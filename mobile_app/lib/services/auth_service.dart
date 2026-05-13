import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';

class AuthService {
  String? _token;
  bool get isLoggedIn => _token != null;

  Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      _token = response.data['access_token'];
      ApiClient.addInterceptors(_token);
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _token = null;
  }
}

final authServiceProvider = Provider((ref) => AuthService());