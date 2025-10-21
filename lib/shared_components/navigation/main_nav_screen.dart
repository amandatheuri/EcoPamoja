import 'package:ecopamoja/shared_components/navigation/navigation_provider.dart';
import 'package:ecopamoja/shared_components/navigation/pages.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navIndexProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? AppColors.background
        : Theme.of(context).scaffoldBackgroundColor;

    final iconColor = isDarkMode ? Colors.grey[300] : Colors.grey[700];
    final tabBackgroundColor = AppColors.primary;
    final activeColor = Colors.black;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: navIndex,
        children: navPages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 14), 
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              gap: 4,
              rippleColor: Colors.green.shade100,
              hoverColor: isDarkMode
                  ? AppColors.background
                  : AppColors.secondary.withOpacity(0.5),
              activeColor: activeColor,
              color: iconColor,
              iconSize: 22,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8), 
              duration: const Duration(milliseconds: 300),
              tabBackgroundColor: tabBackgroundColor,
              backgroundColor: backgroundColor,
              selectedIndex: navIndex,
              onTabChange: (index) {
                ref.read(navIndexProvider.notifier).state = index;
              },
              textStyle: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: activeColor), 
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.eco_rounded, text: 'Challenges'),
                GButton(icon: Icons.group_rounded, text: 'Groups'),
                GButton(icon: Icons.card_giftcard_rounded, text: 'Rewards'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
