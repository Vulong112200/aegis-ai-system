import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../widgets/glass_container.dart';

/// Dashboard Screen - Màn hình chính hiển thị cameras
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // TODO: Connect to BLoC/Provider for camera list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aegis AI System'),
        elevation: 0,
        backgroundColor: AegisTheme.secondaryBlack,
      ),
      backgroundColor: AegisTheme.primaryBlack,
      body: Padding(
        padding: const EdgeInsets.all(AegisTheme.spacingMedium),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Status Card
              GlassContainer(
                backgroundColor: AegisTheme.accentBlue.withOpacity(0.1),
                padding: const EdgeInsets.all(AegisTheme.spacingMedium),
                borderRadius: AegisTheme.radiusLarge,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'System Status',
                          style: AegisTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AegisTheme.accentGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'All Cameras Online',
                              style: AegisTheme.bodyMuted,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: AegisTheme.accentGreen,
                      size: 32,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AegisTheme.spacingLarge),

              // Active Cameras Section
              const Text(
                'Active Cameras',
                style: AegisTheme.headlineSmall,
              ),
              const SizedBox(height: AegisTheme.spacingMedium),

              // Camera Grid (Placeholder)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return GlassContainer(
                    backgroundColor: AegisTheme.accentBlue.withOpacity(0.1),
                    borderRadius: AegisTheme.radiusLarge,
                    onTap: () {
                      // TODO: Navigate to camera detail
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam,
                          size: 40,
                          color: AegisTheme.accentBlue,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Camera ${index + 1}',
                          style: AegisTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Living Room',
                          style: AegisTheme.bodyMuted,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AegisTheme.spacingLarge),

              // Recent Alerts Section
              const Text(
                'Recent Recognition Events',
                style: AegisTheme.headlineSmall,
              ),
              const SizedBox(height: AegisTheme.spacingMedium),

              // Alert List (Placeholder)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AlertGlassCard(
                      title: 'Person Detected',
                      message: 'A person was detected in your home',
                      personName: index == 0 ? 'Dad' : 'Unknown Person',
                      cameraName: 'Living Room Camera',
                      confidence: 0.92,
                      alertColor: index == 0
                          ? AegisTheme.accentGreen
                          : AegisTheme.accentRed,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
