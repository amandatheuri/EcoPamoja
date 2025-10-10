import 'package:ecopamoja/shared_components/navigation/navigation_provider.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EcoNavBar extends ConsumerWidget {
  const EcoNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(navIndexProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0E11).withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, ref, icon: Icons.home_rounded, index: 0, label: "Home"),
          _navItem(context, ref, icon: Icons.emoji_events_rounded, index: 1, label: "Challenges"),
          _navItem(context, ref, icon: Icons.group_rounded, index: 2, label: "Groups"),
          _navItem(context, ref, icon: Icons.card_giftcard_rounded, index: 3, label: "Rewards"),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, WidgetRef ref,
      {required IconData icon, required int index, required String label}) {
    final currentIndex = ref.watch(navIndexProvider);
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => ref.read(navIndexProvider.notifier).state = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: AppColors.primary.withOpacity(0.5), width: 1)
              : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : Colors.white70,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppColors.primary : Colors.white60,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
