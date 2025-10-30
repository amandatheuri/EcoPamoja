// ignore_for_file: use_build_context_synchronously

/*
Step 1: create a stateful widget✅
Step 2: initialize the selected index✅
Step 3: initialize the list that contains the titles of the pages✅
Step 4: Build a scaffold that handles small and big screen content(appbar, drawer, body(stack,
background, row(sidebar, expanded(indexedstack(index,children[list of pages])))
))✅
Step 5: Build a sidebar container that contains the logo, title and list of pages(padding, width, color, 
child(listview(logo, title, list of pages)))✅
Step 6: Build drawer for mobile view(a widget function that returns sidebar)✅
Step 7: Handle the list items when clicked(initialize the selected index to point to the page that has been clicked,
return listtile(selected, title, ontap(setstate({the selected index will now point to the selected item and if on mobile pop context}))))✅
*/
import 'dart:math';

import 'package:ecopamoja/admin/features/dashboard/admin_dashboard_content.dart';
import 'package:ecopamoja/admin/features/dashboard/analytics.dart';
import 'package:ecopamoja/admin/features/challenges/manage_challenges.dart';
import 'package:ecopamoja/admin/features/dashboard/mascot_form.dart';
import 'package:ecopamoja/admin/features/didyouknow/did_you_know_content.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminDashboardOverview extends StatefulWidget {
  const AdminDashboardOverview({super.key});

  @override
  State<AdminDashboardOverview> createState() => _AdminDashboardOverviewState();
}
class _AdminDashboardOverviewState extends State<AdminDashboardOverview> {
  int _selectedIndex = 0;

  final List<String> _title=[
    'Dashboard',
    'Manage Challenges',
    'Analytics',
    'Mascot',
    'Did you know'
  ];
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return Scaffold(
      appBar:AppBar(
        title: Padding(
          padding: !isMobile? EdgeInsets.only(left: 250.0): EdgeInsets.only(left: 0.0),
          child: Text(_title[_selectedIndex], style: Theme.of(context).textTheme.bodyLarge),
        ),
        centerTitle: true,
      ),
      drawer: isMobile? _buildDrawer():null,
      body: Row(
            children: [
                  if(!isMobile)_buildSidebar(),
                  if(!isMobile) const VerticalDivider(color: Colors.white70, width: 1, thickness: 1, endIndent: 60,),
                    Expanded(child: IndexedStack(index: _selectedIndex,children: [
                      AdminDashboardContent(),
                      ManageChallengesScreen(),
                      AdminAnalytics(),
                      AdminMascotPage(),
                      DidYouKnowScreen()
                    ],))
                  ],
                ),        
    );
  }
  Widget _buildSidebar(){
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width < 450 
  ? MediaQuery.of(context).size.width * 0.70 
  : min(MediaQuery.of(context).size.width * 0.25, 250),
      color: AppColors.background,
      child: Column(
      children: [
      Expanded( 
        child: ListView(
          children: [
           Padding(
             padding: const EdgeInsets.only(top: 20.0),
             child: Image.asset(AppImages.logosticker, width: 80, height: 80),
           ),
            const SizedBox(height: 10),
            Text(
              'EcoPamoja Admin',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildNavItem('Dashboard', 0, Icons.dashboard),
            _buildNavItem('Manage Challenges', 1, Icons.task),
            _buildNavItem('Analytics', 2, Icons.analytics),
            _buildNavItem('Mascot', 3, Icons.pets),
            _buildNavItem('Did you know', 4, Icons.question_answer)
          ],
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'Logout',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
          ),
          onTap: () async{
            await FirebaseAuth.instance.signOut();
            context.go('/admin-login');
            },
        ),
      ),
        ],
      ),
    );

  }
  Widget _buildDrawer()=>_buildSidebar();
  Widget _buildNavItem(String title, int index, IconData icon) {
  final isSelected = _selectedIndex == index;
  return ListTile(
    leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),   
    selected: isSelected,
   title: Text(
  _title[index],
  overflow: TextOverflow.ellipsis,
  softWrap: false,
  maxLines: 1,
  style: isSelected
      ? Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.primary,
          fontSize: 16, 
        )
      : Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 16,
        ),
),
    selectedTileColor: Colors.transparent,
    onTap: () {
      setState(() {
        _selectedIndex = index;
        if (ResponsiveBreakpoints.of(context).smallerThan(TABLET)) {
          Navigator.pop(context); // Close the drawer
        }
      });
    },
  );
}

}