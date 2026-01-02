import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/authentication/providers/user_provider.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MascotSection extends ConsumerWidget {
  const MascotSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final now = DateTime.now();
    final lastActive = user.lastActive;
    final daysInactive = now.difference(lastActive).inDays;

    // Stream for all mascot states
    final mascotStatesStream = FirebaseFirestore.instance
        .collection('mascotStates')
        .orderBy('minDaysInactive')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: mascotStatesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final mascotStates = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // Filter mascot state based on inactivity and last challenge type
        final mascot = mascotStates.firstWhere(
          (state) {
            final minDays = state['minDaysInactive'] ?? 0;
            final maxDays = state['maxDaysInactive'] ?? 999;
final List<String>? types =
    (state['challengeTypes'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList();

final bool typeMatches =
    types == null ||
    user.lastChallengeType.any((t) => types.contains(t));

            return daysInactive >= minDays &&
                daysInactive <= maxDays &&
                typeMatches;
          },
          orElse: () => <String, dynamic>{},
        );

        final imageUrl = mascot['image'] ?? '';
        final message = mascot['message'] ?? '';

        return _ecoMascotCard(
          context,
          mascot: imageUrl.isNotEmpty
              ? BobbingMascotImage(imageUrl: imageUrl)
              : const Icon(Icons.public, size: 80, color: Colors.grey),
          streak: user.streak,
          message: message,
        );
      },
    );
  }

  Widget _ecoMascotCard(
    BuildContext context, {
    required Widget mascot,
    required int streak,
    required String message,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Center(child: mascot),
              Positioned(
                right: 16,
                top: 30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.complimentary, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: AppColors.complimentary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$streak",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.complimentary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BobbingMascotImage extends StatefulWidget {
  final String imageUrl;
  const BobbingMascotImage({required this.imageUrl, super.key});

  @override
  State<BobbingMascotImage> createState() => _BobbingMascotImageState();
}

class _BobbingMascotImageState extends State<BobbingMascotImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: -10, end: 10)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Image.network(widget.imageUrl, height: 150, fit: BoxFit.contain),
      ),
    );
  }
}
