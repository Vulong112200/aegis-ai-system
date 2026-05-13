// import 'package:flutter/material.dart';
// import '../../core/theme.dart';
// import '../widgets/glass_container.dart';
// import '../../core/theme.dart';

// /// Dashboard Screen - Màn hình chính hiển thị cameras
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   // TODO: Connect to BLoC/Provider for camera list

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Aegis AI System'),
//         elevation: 0,
//         backgroundColor: AegisTheme.secondaryBlack,
//       ),
//       backgroundColor: AegisTheme.primaryBlack,
//       body: Padding(
//         padding: EdgeInsets.all(AegisTheme.spacingMedium),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // System Status Card
//               GlassContainer(
//                 backgroundColor: AegisTheme.accentBlue.withOpacity(0.1),
//                 padding: EdgeInsets.all(AegisTheme.spacingMedium),
//                 borderRadius: AegisTheme.radiusLarge,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'System Status',
//                           style: AegisTheme.headlineSmall,
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Container(
//                               width: 8,
//                               height: 8,
//                               decoration: const BoxDecoration(
//                                 color: AegisTheme.accentGreen,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'All Cameras Online',
//                               style: AegisTheme.bodyMuted,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const Icon(
//                       Icons.check_circle,
//                       color: AegisTheme.accentGreen,
//                       size: 32,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: AegisTheme.spacingLarge),

//               // Active Cameras Section
//               const Text(
//                 'Active Cameras',
//                 style: AegisTheme.headlineSmall,
//               ),
//               SizedBox(height: AegisTheme.spacingMedium),

//               // Camera Grid (Placeholder)
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   return GlassContainer(
//                     backgroundColor: AegisTheme.accentBlue.withOpacity(0.1),
//                     borderRadius: AegisTheme.radiusLarge,
//                     onTap: () {
//                       // TODO: Navigate to camera detail
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.videocam,
//                           size: 40,
//                           color: AegisTheme.accentBlue,
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           'Camera ${index + 1}',
//                           style: AegisTheme.headlineSmall,
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           'Living Room',
//                           style: AegisTheme.bodyMuted,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: AegisTheme.spacingLarge),

//               // Recent Alerts Section
//               const Text(
//                 'Recent Recognition Events',
//                 style: AegisTheme.headlineSmall,
//               ),
//               SizedBox(height: AegisTheme.spacingMedium),

//               // Alert List (Placeholder)
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: AlertGlassCard(
//                       title: 'Person Detected',
//                       message: 'A person was detected in your home',
//                       personName: index == 0 ? 'Dad' : 'Unknown Person',
//                       cameraName: 'Living Room Camera',
//                       confidence: 0.92,
//                       alertColor: index == 0
//                           ? AegisTheme.accentGreen
//                           : AegisTheme.accentRed,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../widgets/glass_camera_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisTheme.secondaryBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AegisTheme.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AegisTheme.spacingMedium),
              
              // Header Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back,',
                        style: AegisTheme.bodyMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hà Phi Vũ',
                        style: AegisTheme.headlineSmall.copyWith(fontSize: 28),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AegisTheme.accentBlue.withOpacity(0.2),
                    child: const Icon(Icons.person, color: AegisTheme.accentBlue),
                  ),
                ],
              ),
              
              const SizedBox(height: AegisTheme.spacingLarge),
              
              // Tab Title
              Row(
                children: [
                  const Icon(Icons.videocam_rounded, color: AegisTheme.textWhite, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'ACTIVE CAMERAS',
                    style: AegisTheme.bodyMuted.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AegisTheme.textWhite,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AegisTheme.spacingMedium),

              // Danh sách Camera
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    GlassCameraCard(
                      cameraName: 'Front Door Camera',
                      room: 'ENTRANCE',
                      status: 'ONLINE',
                      // Ảnh demo nội thất để test hiệu ứng kính mờ
                      imageUrl: 'https://images.unsplash.com/photo-1558036117-15d82a90b9b1?q=80&w=1000&auto=format&fit=crop',
                    ),
                    GlassCameraCard(
                      cameraName: 'Living Room Cam',
                      room: 'LIVING ROOM',
                      status: 'ONLINE',
                      // Ảnh demo nội thất 2
                      imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?q=80&w=1000&auto=format&fit=crop',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}