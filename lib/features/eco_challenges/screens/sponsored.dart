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
import 'package:ecopamoja/features/eco_challenges/providers/fetchdata_provider.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsoredCarousel extends ConsumerWidget {
  const SponsoredCarousel({super.key});

  Future<void> _openLink(String url, BuildContext context) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sponsoredChallenges = ref.watch(sponsoredChallengesProvider);

    return sponsoredChallenges.when(
      data: (challenges) {
        if (challenges.isEmpty) return const SizedBox();

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
            final formattedDate = date != null
                ? DateFormat(
                    'dd/MM/yyyy',
                  ).format(date is DateTime ? date : date.toDate())
                : 'N/A';

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
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //---Header Row---
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                challenge['partnerLogoKey'],
                              ),
                              radius: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              challenge['partnerName'],
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Sponsored +${challenge['pointsToAward']} pts",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // --- Description ---
                        Text(
                          challenge['description'],
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _openLink(link, context),
                          child: Text(
                            "Visit store",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // --- Footer Row ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => _openLink(link, context),
                              child: Text(
                                "Done",
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
