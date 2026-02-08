import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/features/settings_debug_menu/settings_screen.dart';
import 'package:flutter/material.dart';

class FeatureDisabledWidget extends StatelessWidget {
  final String featureName;
  final IconData icon;
  final Color iconColor;
  final String message;

  const FeatureDisabledWidget({
    super.key,
    required this.featureName,
    required this.icon,
    required this.iconColor,
    this.message = 'This feature is currently disabled',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: iconColor.withOpacity(0.5)),
            ),
            const GapH(24),
            Text(
              featureName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const GapH(12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const GapH(32),

            ElevatedButton.icon(
              onPressed: () {
                SettingsBottomSheet.show(context);
              },
              icon: const Icon(Icons.settings),
              label: const Text('Enable from Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: iconColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const GapH(16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You can enable this feature anytime from the Settings screen',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
