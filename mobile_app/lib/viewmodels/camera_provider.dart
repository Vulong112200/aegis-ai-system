import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';
import '../domain/camera_model.dart';

// FutureProvider tự động quản lý 3 trạng thái: Loading, Success (Data), Error
final cameraListProvider = FutureProvider<List<CameraModel>>((ref) async {
  // Lấy ra instance của Dio đã được cấu hình sẵn base_url ở Phase 7
  final dio = ref.watch(apiClientProvider);
  
  try {
    final response = await dio.get('/cameras');
    if (response.statusCode == 200 && response.data['status'] == 'success') {
      final List rawData = response.data['data'];
      return rawData.map((json) => CameraModel.fromJson(json)).toList();
    }
    return [];
  } catch (e) {
    throw Exception('Không thể tải danh sách Camera: $e');
  }
});