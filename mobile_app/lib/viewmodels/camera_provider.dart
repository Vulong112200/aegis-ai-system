import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/camera_model.dart';
import '../services/auth_service.dart';

class CameraProvider extends StateNotifier<List<CameraModel>> {
  CameraProvider() : super([]);

  Future<void> loadCameras() async {
    // Load cameras from API
    // state = loadedCameras;
  }

  Future<void> addCamera(CameraModel camera) async {
    // Add camera via API
    state = [...state, camera];
  }
}

final cameraProvider = StateNotifierProvider<CameraProvider, List<CameraModel>>(
  (ref) => CameraProvider(),
);