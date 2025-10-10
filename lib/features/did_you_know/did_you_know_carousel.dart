// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecopamoja/features/did_you_know/did_you_know_provider.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DidYouKnowCarousel extends ConsumerWidget {
  const DidYouKnowCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factsAsync = ref.watch(didYouKnowProvider);

    return factsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (facts) {
        return CarouselSlider.builder(
          itemCount: facts.length,
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            viewportFraction: 1,
          ),
          itemBuilder: (context, index, realIdx) {
            final fact = facts[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(107, 53, 184, 156),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Light bulb icon + page counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.lightbulb_rounded,
                            color: AppColors.complimentary, size: 28),
                        Text(
                          '${index + 1}/${facts.length}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
              
                    // Title
                    Text(
                      'Did you know?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
              
                    // Fact text
                    Expanded(
                      child: Text(
                        fact.fact,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              height: 1.5,
                            ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
              
                    // Buttons: Explore + Share
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            textStyle: Theme.of(context).textTheme.labelSmall,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: const Size(0, 0),
                          ),
                          onPressed: () async {
                            final url = Uri.parse(fact.blogLink);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          child: const Text(
                            'Explore',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            Share.share(
                                '${fact.fact}\nRead more: ${fact.blogLink}');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
