// ignore_for_file: deprecated_member_use, use_build_context_synchronously
/* 
Step 1: Create stateful widget for managing challenges
Step 2: initialize a scroll controller to handle horizontal scrolling and set show arrow to false
Step 3: create a function to check if the scroll view is overflowing
Step 4: create a toggle button to switch between quiz and action challenges
Step 5: create a button to add new challenges
*/
import 'package:ecopamoja/admin/features/challenges/forms/action_challenge_form.dart';
import 'package:ecopamoja/admin/features/challenges/forms/quiz_challenge_form.dart';
import 'package:ecopamoja/admin/features/challenges/forms/sponsoredform.dart';
import 'package:ecopamoja/admin/features/widgets/action_challenge.dart';
import 'package:ecopamoja/admin/features/widgets/action_challenge_type.dart';
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
                        _buildAddButton(context, _selectedTab),
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
                              colors: [
                                Colors.transparent,
                                AppColors.background.withOpacity(0.9),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
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
                    Row(children: [_buildToggleButtons(isMobile)]),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildAddButton(context, _selectedTab),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedTab == 0
                  ? QuizChallengeManager()
                  : ActionChallengesPage(),
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

  Widget _buildAddButton(BuildContext context, int selectedTab) {
    return ElevatedButton(
      onPressed: () async {
        final selectedType = await showDialog<String>(
          context: context,
          builder: (context) => ActionChallengeType(),
        );

        if (selectedType == null) return;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            Widget content;
            switch (selectedType) {
              case 'normal':
                content = const AddActionChallengeDialog();
                break;
              case 'sponsored':
                content = SponsoredInputForm();
                break;
              default:
                content = const AddQuizChallengeDialog();
            }

            return AlertDialog(
              contentPadding: const EdgeInsets.all(14),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: content,
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
