import 'package:flutter/material.dart';
import '../../models/event_model.dart';

class EventListTile extends StatelessWidget {
  final EventModel event;

  const EventListTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${event.eventType} - ${event.confidence}'),
      subtitle: Text(event.timestamp.toString()),
    );
  }
}