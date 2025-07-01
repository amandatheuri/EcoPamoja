import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
class ManageStoreItems extends StatelessWidget {
  const ManageStoreItems({super.key,});
@override
 Widget build(BuildContext context){
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
  return Scaffold(
    body: Center(child: Stack(
          children: [
                Center(
                  child: Container(
                      constraints: BoxConstraints(
                  maxHeight: isMobile ? 550 : double.infinity,
                  maxWidth: isMobile ? 500 : double.infinity,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16.0 : 40.0,
                  vertical: 16.0,
                ),
                child: SingleChildScrollView(
                  
                ),
                  )
                  )
          ],
        )),
  );
 }
}