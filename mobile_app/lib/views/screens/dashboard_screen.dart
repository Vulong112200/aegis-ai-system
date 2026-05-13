import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/camera_provider.dart';
import '../widgets/glass_camera_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameras = ref.watch(cameraProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView.builder(
        itemCount: cameras.length,
        itemBuilder: (context, index) {
          return GlassCameraCard(camera: cameras[index]);
        },
      ),
    );
  }
}