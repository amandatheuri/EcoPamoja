import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/authentication/providers/user_provider.dart';
import '../../../shared_components/appbar/custom_appbar.dart';

class AdminUserProfile extends ConsumerWidget {
  const AdminUserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // user details provider instance
    final user = ref.watch(userDataProvider);

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverEcoAppBar(),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
