/* 
Display : Complete challenges text, 
sponsored challenges/collabs, 
quiz challenges container, 
daily habits, 
waste reduction. 
Container details: 
each container should show number of new challenges added that day, 
user progress i.e number of challenges completed for the day out of 3, 
line bar progress. 
UI: 
progress bar- completed bar- primary, 
not completed- turqoise 
Quizzes- colors.dart: primary, icon: brain 
daily habits- colors.dart: complimentary, icon: leaf 
waste reduction- colors.dart: turqoise, icon: trash can 
*/
import 'package:ecopamoja/features/eco_challenges/screens/sponsored.dart';
import 'package:ecopamoja/shared_components/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserChallenges extends ConsumerWidget {
  const UserChallenges({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomEcoAppBar(), 
      body: SingleChildScrollView(
          //Heading
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //bold text
                  Row(
                    children: [
                  Text(
                    'Complete Challenges',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  //subtitle
                  Expanded(
                    child: Text(
                      'to earn',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'badges and level up!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w100,
                    ),
                    ),
                  SizedBox(height: 20),
                  //sponsored content
                  SponsoredCarousel(),
                ],
              ),
            ),
      
      ),
    );
  }
}
