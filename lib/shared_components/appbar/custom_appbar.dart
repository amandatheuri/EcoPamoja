import 'package:ecopamoja/features/authentication/providers/user_provider.dart';
import 'package:ecopamoja/shared_components/appbar/user_profile.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomEcoAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomEcoAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Glowing Profile Button
          glowingProfileCircle(context, user?.photoUrl ?? ''),
          const SizedBox(width: 12),

          // Greeting + Username
          Expanded(
            child: Text(
              'Hi, ${user?.username ?? "..."}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(179, 221, 221, 221),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Notification Icon with counter
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 24),
                onPressed: () {},
              ),
              Positioned(
                right: 7.5,
                top: 5,
                child: Container(
                  width: 13.5,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.complimentary,
                  ),
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
