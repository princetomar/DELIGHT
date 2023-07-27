import 'package:delight/core/common/error_text.dart';
import 'package:delight/core/common/loader.dart';
import 'package:delight/core/common/post_card.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/features/community/controller/community_controller.dart';
import 'package:delight/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({
    required this.name,
  });

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get access to user uid
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innderBoxisScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(children: [
                      Positioned.fill(
                        child: Image.network(
                          community.banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ]),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 35,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'd/${community.name}',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!isGuest)
                                community.mods.contains(user.uid)
                                    ? OutlinedButton(
                                        onPressed: () {
                                          navigateToModTools(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25),
                                        ),
                                        child: Text(
                                          "Mod Tools ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : OutlinedButton(
                                        onPressed: () => joinCommunity(
                                            ref, community, context),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25),
                                        ),
                                        child: Text(
                                          community.members.contains(user.uid)
                                              ? "Joined"
                                              : "Join",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(community.members.length >= 2
                                  ? "${community.members.length} memebers"
                                  : "${community.members.length} memeber")),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getCommunityPostsProvider(name)).when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = data[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
            ),
            error: (error, stackTrace) {
              ErrorText(
                error: error.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
