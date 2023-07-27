import 'package:delight/core/common/error_text.dart';
import 'package:delight/core/common/loader.dart';
import 'package:delight/core/common/sign_in_button.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/features/community/controller/community_controller.dart';
import 'package:delight/models/community_model.dart';
import 'package:delight/theme/pallets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/d/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? Column(
                    children: [
                      SignInButton(
                        isFromLogin: false,
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.greyColor,
                            minimumSize:
                                Size(double.infinity, size.height * 0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        onPressed: () {
                          ref
                              .watch(authControllerProvider.notifier)
                              .logOutAsGuest();
                        },
                        child: Text(
                          "Sign Out",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                : ListTile(
                    title: const Text(
                      "Create a Community",
                    ),
                    leading: Icon(Icons.add),
                    onTap: () => navigateToCreateCommunity(context),
                  ),
            if (!isGuest)
              ref.watch(userCommunitiesProvider).when(
                  data: (communities) => Expanded(
                        child: ListView.builder(
                            itemCount: communities.length,
                            itemBuilder: ((context, index) {
                              // extract a particular community from the list of communities
                              final community = communities[index];
                              return ListTile(
                                title: Text('D/${community.name}'),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    community.avatar,
                                  ),
                                ),
                                onTap: () {
                                  navigateToCommunity(context, community);
                                },
                              );
                            })),
                      ),
                  error: (error, stackTree) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader())
          ],
        ),
      ),
    );
  }
}
