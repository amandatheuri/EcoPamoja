import 'package:ecopamoja/admin/routing/admin_router.dart';
import 'package:ecopamoja/admin/theme/admin_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminApp extends StatelessWidget{
const AdminApp({super.key});
@override
Widget build (BuildContext context){
  return MaterialApp.router(
    routerConfig: adminRouter,
    debugShowCheckedModeBanner: false,
    theme: AdminTheme.darkTheme,
    builder: (context, child) => ResponsiveBreakpoints.builder(
      child: child!, 
      breakpoints: [
         const Breakpoint(start: 0, end: 450, name: MOBILE),
         const Breakpoint(start: 451, end: 800, name: TABLET),
         const Breakpoint(start: 801, end: 1920, name: DESKTOP),
         const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ]
      )

  );
}
}