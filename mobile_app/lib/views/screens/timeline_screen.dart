import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/timeline_provider.dart';
import '../widgets/event_list_tile.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(timelineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Timeline')),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventListTile(event: events[index]);
        },
      ),
    );
  }
}