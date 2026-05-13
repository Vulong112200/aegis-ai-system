import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';

class TimelineProvider extends StateNotifier<List<EventModel>> {
  TimelineProvider() : super([]);

  Future<void> loadEvents() async {
    // Load events from API
    // state = loadedEvents;
  }

  void filterEvents(String filter) {
    // Filter events based on criteria
  }
}

final timelineProvider = StateNotifierProvider<TimelineProvider, List<EventModel>>(
  (ref) => TimelineProvider(),
);