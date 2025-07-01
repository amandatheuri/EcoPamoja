// ignore_for_file: deprecated_member_use

import 'package:ecopamoja/admin/features/dashboard/challenges/action_challenge_form.dart';
import 'package:ecopamoja/admin/features/dashboard/challenges/quiz_challenge_form.dart';
import 'package:ecopamoja/admin/features/widgets/action_challenge.dart';
import 'package:ecopamoja/admin/features/widgets/quiz_challenge.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ManageChallengesScreen extends StatefulWidget {
  const ManageChallengesScreen({super.key});

  @override
  State<ManageChallengesScreen> createState() => _ManageChallengesScreenState();
}

class _ManageChallengesScreenState extends State<ManageChallengesScreen> {
  final ScrollController _scrollController = ScrollController();
bool _showScrollArrow = false;

  int _selectedTab = 0;
@override
void initState() {
  super.initState();
  _scrollController.addListener(_checkScrollOverflow);
  WidgetsBinding.instance.addPostFrameCallback((_) => _checkScrollOverflow());
}

@override
void dispose() {
  _scrollController.removeListener(_checkScrollOverflow);
  _scrollController.dispose();
  super.dispose();
}
void _checkScrollOverflow() {
  if (!_scrollController.hasClients) return;

  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.offset;
  final isOverflowing = maxScroll > 0 && currentScroll < maxScroll;

  if (_showScrollArrow != isOverflowing) {
    setState(() {
      _showScrollArrow = isOverflowing;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isMobile)
              Stack(
  children: [
    SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildToggleButtons(isMobile),
          const SizedBox(width: 16),
          _buildAddButton()
        ],
      ),
    ),
    if (_showScrollArrow)
      Positioned(
        right: 5,
        top: 0,
        bottom: 0,
        child: IgnorePointer(
          child: Container(
            width: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.transparent, AppColors.background.withOpacity(0.9)],
              ),
            ),
            child: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ),
        ),
      ),
  ],
),

            if (isMobile)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildToggleButtons(isMobile),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildAddButton(),
                      ),
                    ],
                  ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedTab == 0
                  ? QuizChallengeManager()
                  : ActionChallengeManager(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons(bool isMobile) {
    return ToggleButtons(
      isSelected: [_selectedTab == 0, _selectedTab == 1],
      onPressed: (index) {
        setState(() {
          _selectedTab = index;
        });
      },
      borderRadius: BorderRadius.circular(8),
      selectedColor: Colors.white,
      fillColor: AppColors.primary,
      color: AppColors.secondary,
      constraints: BoxConstraints(
        minHeight: 40,
        minWidth: isMobile ? 100 : 160,
      ),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Quiz Challenges'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Action Challenges'),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
  return ElevatedButton(
    onPressed: () {
      showDialog(
        context: context,
        barrierDismissible: true, // allows closing the dialog when tapping outside
        builder: (_) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(20),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6, // Responsive width
              child: _selectedTab == 0
                  ? AddQuizChallengeDialog()
                  : AddActionChallengeDialog(),
            ),
          );
        },
      );
    },
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.primary, width: 2),
      ),
      padding: const EdgeInsets.all(12),
      backgroundColor: AppColors.primary,
    ),
    child: const Icon(Icons.add, color: Colors.white),
  );
}

}
