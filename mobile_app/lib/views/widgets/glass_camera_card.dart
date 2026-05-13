import 'package:flutter/material.dart';
import '../../models/camera_model.dart';

class GlassCameraCard extends StatelessWidget {
  final CameraModel camera;

  const GlassCameraCard({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: ListTile(
        title: Text(camera.name),
        subtitle: Text(camera.location),
        trailing: Icon(
          camera.isOnline ? Icons.online_prediction : Icons.offline_bolt,
          color: camera.isOnline ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}