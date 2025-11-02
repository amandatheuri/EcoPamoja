import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/authentication/controllers/auth_controller.dart';
import '../../../features/authentication/providers/user_provider.dart';
import '../../../theme_essentials/colors.dart';
import '../widgets/user_details.dart';

class AdminUserProfile extends ConsumerWidget {
  const AdminUserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // user details provider instance
    final user = ref.watch(userDataProvider);
    final authController = ref.watch(authControllerProvider);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              expandedHeight: 10,
              backgroundColor: Colors.transparent,
              flexibleSpace: SizedBox(),
              title: Text("User profile: ${user?.username}"),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user?.photoUrl ?? ''),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // user details
                        Container(
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: Colors.grey.shade100,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Username: ${user?.username}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      Text(
                                        "Bio: ${user?.email}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // profile overview
                        Text(
                          "Overall data",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primaryCompliment,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              UserDetailsRow(
                                detailTitle: "Created at:",
                                detailData: user?.createdAt.toString(),
                              ),
                              const SizedBox(height: 10),
                              UserDetailsRow(
                                detailTitle: "Last active:",
                                detailData: user?.lastActive.toString(),
                              ),
                              const SizedBox(height: 10),
                              UserDetailsRow(
                                detailTitle: "Streak",
                                detailData: user?.streak.toString(),
                              ),
                              const SizedBox(height: 10),
                              UserDetailsRow(
                                detailTitle: "Total points",
                                detailData: user?.pointsEarned.toString(),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    print("Signing out...");
                    await authController.signOut();
                    context.go('/sign-up');
                  },
                  child: const Text(
                    "Log out",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
