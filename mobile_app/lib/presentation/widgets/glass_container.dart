import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'dart:ui';

/// Glass Morphism Container Widget
/// Tạo hiệu ứng kính mờ dán trên nền (Tesla Style)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets padding;
  final double borderRadius;
  final double blur;
  final Color backgroundColor;
  final Border? border;
  final VoidCallback? onTap;

  const GlassContainer({
    Key? key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.blur = 10,
    this.backgroundColor = const Color.fromARGB(30, 0, 217, 255),
    this.border,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              // Glass effect gradient
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor.withOpacity(0.4),
                  backgroundColor.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ??
                  Border.all(
                    color: AegisTheme.accentBlue.withOpacity(0.3),
                    width: 1.5,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Alert Glass Card - Thẻ thông báo với hiệu ứng kính
class AlertGlassCard extends StatelessWidget {
  final String title;
  final String message;
  final String? personName;
  final String? cameraName;
  final double confidence;
  final Color alertColor;
  final String? snapshotUrl;

  const AlertGlassCard({
    Key? key,
    required this.title,
    required this.message,
    this.personName,
    this.cameraName,
    this.confidence = 0.0,
    this.alertColor = const Color(0xFFE82127),
    this.snapshotUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      backgroundColor: alertColor.withOpacity(0.2),
      borderRadius: 12,
      blur: 15,
      padding: const EdgeInsets.all(16),
      border: Border.all(
        color: alertColor.withOpacity(0.5),
        width: 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: alertColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFECEFF1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (cameraName != null)
                      Text(
                        'Camera: $cameraName',
                        style: const TextStyle(
                          color: Color(0xFF90A4AE),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFFECEFF1),
              fontSize: 14,
            ),
          ),
          if (personName != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Person: $personName',
                  style: const TextStyle(
                    color: Color(0xFF00D9FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (confidence > 0)
                  Text(
                    'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Color(0xFF2ECC71),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Status Indicator Badge - Biểu tượng trạng thái
class StatusBadge extends StatelessWidget {
  final String status;
  final Color? backgroundColor;

  const StatusBadge({
    Key? key,
    required this.status,
    this.backgroundColor,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toUpperCase()) {
      case 'ONLINE':
        return AegisTheme.accentGreen;
      case 'OFFLINE':
        return AegisTheme.accentRed;
      case 'PROCESSING':
        return AegisTheme.accentBlue;
      default:
        return AegisTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getStatusColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
