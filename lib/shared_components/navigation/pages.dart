import 'package:ecopamoja/features/eco_challenges/screens/challenges.dart';
import 'package:ecopamoja/features/groups/main_groups_screen.dart';
import 'package:ecopamoja/features/home/screens/homescreenmanager.dart';
import 'package:ecopamoja/features/rewards/rewards_main_screen.dart';
import 'package:flutter/widgets.dart';

final List<Widget> navPages= [
   HomePage(),
   UserChallenges(),
   Groups(),
   Rewards(),
];
final List<String> navPagesTitles=[
   'Home',
   'Challenges',
   'Groups',
   'Rewards',
];