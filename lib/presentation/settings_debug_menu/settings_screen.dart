// lib/features/settings/presentation/settings_bottom_sheet.dart
import 'package:aitie_demo/constants/gap.dart';
import 'package:aitie_demo/presentation/settings_debug_menu/cubit/feature_flag_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  // Static method to show the bottom sheet
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SettingsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          Expanded(
            child: BlocBuilder<FeatureFlagCubit, FeatureFlagState>(
              builder: (context, state) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Feature Flags',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const GapH(8),
                    Text(
                      'Enable or disable app features',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const GapH(24),

                    // Favorites Feature
                    _FeatureFlagTile(
                      title: 'Favorites',
                      subtitle: 'Enable favorite products feature',
                      icon: Icons.favorite,
                      iconColor: Colors.red,
                      value: state.isFavoritesEnabled,
                      onChanged: (value) {
                        context.read<FeatureFlagCubit>().toggleFavorites(value);
                      },
                    ),
                    const Divider(),

                    // Cart Feature
                    _FeatureFlagTile(
                      title: 'Shopping Cart',
                      subtitle: 'Enable shopping cart feature',
                      icon: Icons.shopping_cart,
                      iconColor: Colors.green,
                      value: state.isCartEnabled,
                      onChanged: (value) {
                        context.read<FeatureFlagCubit>().toggleCart(value);
                      },
                    ),
                    const Divider(),

                    // Offline Caching Feature
                    _FeatureFlagTile(
                      title: 'Offline Caching',
                      subtitle:
                          'Store products locally for offline access. Turning off will clear cached data.',
                      icon: Icons.storage,
                      iconColor: Colors.blue,
                      value: state.isOfflineCachingEnabled,
                      onChanged: (value) {
                        if (!value) {
                          // Show confirmation dialog before disabling
                          _showConfirmationDialog(
                            context,
                            title: 'Clear Cached Data?',
                            message:
                                'Disabling offline caching will clear all locally stored product data. Continue?',
                            onConfirm: () {
                              context
                                  .read<FeatureFlagCubit>()
                                  .toggleOfflineCaching(value);
                            },
                          );
                        } else {
                          context.read<FeatureFlagCubit>().toggleOfflineCaching(
                            value,
                          );
                        }
                      },
                    ),
                    const Divider(),

                    const GapH(24),

                    // Developer Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Developer Info',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const GapH(12),
                          Text(
                            'Tip: Tap the Favorite tab 5 times to enable debug menu',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const GapH(16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _FeatureFlagTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FeatureFlagTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      secondary: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: iconColor,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
