import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';

class RealtimeService {
  // Implement WebSocket or Supabase Realtime connection
  void connect() {
    // Connect to WebSocket for real-time updates
  }

  void disconnect() {
    // Disconnect from WebSocket
  }

  Stream listenToEvents() {
    // Return stream of events
    return Stream.empty();
  }
}

final realtimeServiceProvider = Provider((ref) => RealtimeService());