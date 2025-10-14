import "package:flutter/material.dart";

class AdminUserProfile extends StatefulWidget {
  const AdminUserProfile({super.key});

  @override
  State<AdminUserProfile> createState() => _AdminUserProfileState();
}

class _AdminUserProfileState extends State<AdminUserProfile> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(
            context,
          ).scaffoldBackgroundColor.withValues(green: 0.4, alpha: 0.3),
          centerTitle: true,
          title: Text("User profile"),
        ),
        SliverPadding(padding: const EdgeInsets.all(5)),
        SliverToBoxAdapter(
          child: Center(
            child: Text(
              "User profile in development.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
