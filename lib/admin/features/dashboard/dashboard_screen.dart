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
import 'package:ecopamoja/admin/features/dashboard/admin_dashboard_content.dart';
import 'package:ecopamoja/admin/features/dashboard/analytics.dart';
import 'package:ecopamoja/admin/features/dashboard/challenges/manage_challenges.dart';
import 'package:ecopamoja/admin/features/dashboard/manage_store_items.dart';
import 'package:ecopamoja/platform_check_stub.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
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
    'Manage Store Items',
    'Manage Challenges',
    'Analytics',
  ];
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return Scaffold(
      appBar:AppBar(
        title: Padding(
          padding: !isMobile? EdgeInsets.only(left: 250.0): EdgeInsets.only(left: 0.0),
          child: Text(_title[_selectedIndex], style: AppTextStyles.title),
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
                      ManageStoreItems(),
                      ManageChallengesScreen(),
                      AdminAnalytics(),
                    ],))
                  ],
                ),
        
      
      
        
    );
  }
  Widget _buildSidebar(){
    return Container(
      height: double.infinity,
      width: !isMobile? (MediaQuery.of(context).size.width * 0.25 > 250
    ? 250 : MediaQuery.of(context).size.width * 0.25): null,
      color: AppColors.background,
      child: Column(
      children: [
      Expanded( 
        child: ListView(
          children: [
           Padding(
             padding: const EdgeInsets.only(top: 1.0),
             child: Image.asset(AppImages.logosticker, width: 80, height: 80),
           ),
            const SizedBox(height: 10),
            Text(
              'EcoPamoja Admin',
              style: AppTextStyles.title.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildNavItem('Dashboard', 0, Icons.dashboard),
            _buildNavItem('Manage Store Items', 1, Icons.store),
            _buildNavItem('Manage Challenges', 2, Icons.task),
            _buildNavItem('Analytics', 3, Icons.analytics),
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
            style: AppTextStyles.bodyText.copyWith(color: AppColors.secondary, fontSize: 16),
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
      ? AppTextStyles.bodyText.copyWith(
          color: AppColors.primary,
          fontSize: 16, 
        )
      : AppTextStyles.bodyText.copyWith(
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