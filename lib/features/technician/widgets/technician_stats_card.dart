import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_card.dart';

class TechnicianStatsCard extends StatelessWidget {

  const TechnicianStatsCard({
    required this.title, required this.value, required this.icon, required this.color, super.key,
    this.trend,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textColor.withOpacity(0.7),
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 8),
              Text(
                trend!,
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}