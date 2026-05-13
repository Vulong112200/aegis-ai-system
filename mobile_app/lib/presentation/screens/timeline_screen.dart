import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../widgets/glass_container.dart';

/// Timeline Screen - Hiển thị lịch sử nhận diện
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  // TODO: Connect to BLoC/Provider for recognition history

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recognition Timeline'),
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
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: true,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Known People',
                      isSelected: false,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Unknown',
                      isSelected: false,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Today',
                      isSelected: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AegisTheme.spacingLarge),

              // Timeline Events (Placeholder)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return _TimelineEvent(
                    personName: index % 2 == 0 ? 'Dad' : 'Unknown Person ${index ~/ 2}',
                    cameraName: 'Living Room Camera',
                    timestamp: DateTime.now().subtract(
                      Duration(hours: index),
                    ),
                    confidence: 0.85 + (index * 0.02),
                    isKnown: index % 2 == 0,
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

/// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AegisTheme.accentBlue
              : AegisTheme.secondaryBlack,
          border: Border.all(
            color: isSelected
                ? AegisTheme.accentBlue
                : AegisTheme.borderColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AegisTheme.primaryBlack
                : AegisTheme.textLight,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// Timeline Event Card
class _TimelineEvent extends StatelessWidget {
  final String personName;
  final String cameraName;
  final DateTime timestamp;
  final double confidence;
  final bool isKnown;

  const _TimelineEvent({
    required this.personName,
    required this.cameraName,
    required this.timestamp,
    required this.confidence,
    required this.isKnown,
  });

  String _formatTime() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        backgroundColor: (isKnown
                ? AegisTheme.accentGreen
                : AegisTheme.accentRed)
            .withOpacity(0.1),
        borderRadius: AegisTheme.radiusMedium,
        padding: const EdgeInsets.all(AegisTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isKnown
                                  ? AegisTheme.accentGreen
                                  : AegisTheme.accentRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              personName,
                              style: const TextStyle(
                                color: AegisTheme.textLight,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cameraName,
                        style: const TextStyle(
                          color: AegisTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(confidence * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: AegisTheme.accentBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatTime(),
                      style: const TextStyle(
                        color: AegisTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
