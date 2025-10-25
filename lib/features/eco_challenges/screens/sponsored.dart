/* 
Display:
Container,
Brand image if collaboration else do not display container
Brand logo top leftfetch from db
Challenge expiry date left next to logo fetch from db
Point chip top right standard: 15pts
Challenge details fetch from db
Brand url fetch from db
Done button. If user has clicked url award points else error -> 'link not clicked'

logic:
use consumer to read data fetched by provider
watch fetchdata provider
handle display when firestore has no collabs
display carousel
handle done button logic when user visits a url
*/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/eco_challenges/providers/fetchdata_provider.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsoredCarousel extends ConsumerWidget {
  const SponsoredCarousel({super.key});

  Future<void> _openLinkAndAwardPoints(
    String url,
    BuildContext context,
    int pointsToAward,
    String challengeId,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // --- Check if user already completed this challenge ---
    final userSnap = await userRef.get();
    final completedList =
        List<String>.from(userSnap.data()?['completedSponsored'] ?? []);

    if (completedList.contains(challengeId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗Already completed this challenge')),
      );
      return;
    }

    // --- Step 1: Open link ---
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('❌ Error launching link: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
      return;
    }

    // --- Step 2: Add points + mark as completed ---
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) return;

        final currentPoints = snapshot.data()?['pointsEarned'] ?? 0;
        final updatedList = List<String>.from(
          snapshot.data()?['completedSponsored'] ?? [],
        );

        updatedList.add(challengeId);

        transaction.update(userRef, {
          'pointsEarned': currentPoints + pointsToAward,
          'completedSponsored': updatedList,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ You earned $pointsToAward points!')),
      );
    } catch (e) {
      debugPrint('❌ Error updating points: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding points')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sponsoredChallenges = ref.watch(sponsoredChallengesProvider);

    return sponsoredChallenges.when(
      data: (challenges) {
        if (challenges.isEmpty) return const SizedBox();

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, userSnapshot) {
            final completedList = List<String>.from(
              userSnapshot.data!.get('completedSponsored') ?? [],
            );

            return CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1,
              ),
              items: challenges.map((challenge) {
                final String link = challenge['storeLink'] ?? '';
                final date = challenge['dueDate'];
                final challengeId =
                    challenge['id'] ?? challenge.hashCode.toString();
                final pointsToAward = challenge['pointsToAward'] ?? 15;
                final formattedDate = date != null
                    ? DateFormat('dd/MM/yyyy').format(
                        date is DateTime ? date : date.toDate(),
                      )
                    : 'N/A';

                final alreadyDone = completedList.contains(challengeId);

                return Builder(
                  builder: (context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(challenge['brandImage'] ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Header ---
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      challenge['partnerLogoKey']),
                                  radius: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    challenge['partnerName'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Sponsored +$pointsToAward pts",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // --- Description ---
                            Text(
                              challenge['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            const Spacer(),

                            // --- Footer Row ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: alreadyDone
                                      ? null
                                      : () => _openLinkAndAwardPoints(
                                            link,
                                            context,
                                            pointsToAward,
                                            challengeId,
                                          ),
                                  child: Row(
                                    children: [
                                      if (alreadyDone)
                                        const Icon(Icons.check_circle,
                                            color: Colors.grey, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        alreadyDone ? "Completed" : "Done",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: alreadyDone
                                                  ? Colors.grey
                                                  : AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Expires $formattedDate",
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
