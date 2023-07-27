import 'package:any_link_preview/any_link_preview.dart';
import 'package:delight/core/common/error_text.dart';
import 'package:delight/core/common/loader.dart';
import 'package:delight/core/constants/constants.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/features/community/controller/community_controller.dart';
import 'package:delight/features/posts/controller/post_controller.dart';
import 'package:delight/theme/pallets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../models/post_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = post.type == "image";
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final size = MediaQuery.of(context).size;
    final isGuest = !user.isAuthenticated;

    void deletePost(WidgetRef ref, BuildContext context) async {
      ref.read(postControllerProvider.notifier).deletePost(post, context);
    }

    void upvotePost(WidgetRef ref, BuildContext context) async {
      ref.read(postControllerProvider.notifier).upvote(post);
    }

    void downvotePost(WidgetRef ref, BuildContext context) async {
      ref.read(postControllerProvider.notifier).downvote(post);
    }

    void awardPost(WidgetRef ref, BuildContext context, String award) async {
      ref
          .read(postControllerProvider.notifier)
          .awardPost(post: post, award: award, context: context);
    }

    void navigateToUser(BuildContext context) {
      Routemaster.of(context).push('/u/${post.uid}');
    }

    void navigateToCommunity(BuildContext context) {
      Routemaster.of(context).push('/d/${post.communityName}');
    }

    void navigateToComments(BuildContext context) {
      Routemaster.of(context).push('/post/${post.id}/comments');
    }

    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => navigateToCommunity(context),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage:
                                        NetworkImage(post.communityProfilePic),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'r/${post.communityName}',
                                        style: currentTheme.textTheme.bodyText2!
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => navigateToUser(context),
                                        child: Text(
                                          'u/${post.username}',
                                          style: currentTheme
                                              .textTheme.bodyText2!
                                              .copyWith(
                                            color: currentTheme
                                                .textTheme.bodyText2!.color!
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (post.uid == user.uid)
                              IconButton(
                                onPressed: () => deletePost(ref, context),
                                icon: Icon(
                                  Icons.delete,
                                  color: Pallete.redColor,
                                ),
                              ),
                          ],
                        ),
                        if (post.awards.isNotEmpty) ...[
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final award = post.awards[index];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 35,
                                  );
                                }),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isTypeImage)
                          SizedBox(
                            height: size.height * 0.35,
                            width: double.infinity,
                            child: Image.network(
                              post.link!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (isTypeLink)
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 5),
                              height: size.height * 0.15,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              )),
                        if (isTypeText)
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              post.description!,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: isGuest
                                      ? () {}
                                      : () => upvotePost(ref, context),
                                  icon: Icon(
                                    Constants.up,
                                    size: 30,
                                    color: post.upvotes.contains(user.uid)
                                        ? Pallete.redColor
                                        : null,
                                  ),
                                ),
                                Text(
                                  '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                IconButton(
                                  onPressed: isGuest
                                      ? () {}
                                      : () => downvotePost(ref, context),
                                  icon: Icon(
                                    Constants.down,
                                    size: 30,
                                    color: post.downvotes.contains(user.uid)
                                        ? Pallete.blueColor
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => navigateToComments(context),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: Icon(
                                      Icons.comment,
                                    ),
                                  ),
                                  Text(
                                    '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ref
                                .watch(getCommunityByNameProvider(
                                    post.communityName))
                                .when(
                                  data: (data) {
                                    if (data.mods.contains(user.uid)) {
                                      return IconButton(
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            backgroundColor:
                                                currentTheme.backgroundColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            title: const Text('Delete Post'),
                                            content: const Text(
                                                'Are you sure you want to delete this post?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: Text(
                                                  'Cancel',
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    deletePost(ref, context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.admin_panel_settings,
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  },
                                  error: (error, stackTrace) => ErrorText(
                                    error: error.toString(),
                                  ),
                                  loading: () => const Loader(),
                                ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: Container(
                                      height: size.height * 0.28,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GridView.builder(
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                            ),
                                            itemCount: user.awards.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final awards = user.awards[index];
                                              return GestureDetector(
                                                onTap: () => awardPost(
                                                    ref, context, awards),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Image.asset(Constants
                                                      .awards[awards]!),
                                                ),
                                              );
                                            },
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Routemaster.of(context).push(
                                                    '/payments/:${user.name}');
                                              },
                                              child: Text(
                                                "Get More",
                                                style: TextStyle(fontSize: 20),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.card_giftcard_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}
