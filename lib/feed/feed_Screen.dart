import 'package:delight/core/common/error_text.dart';
import 'package:delight/core/common/loader.dart';
import 'package:delight/core/common/post_card.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/features/community/controller/community_controller.dart';
import 'package:delight/features/posts/controller/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) =>
                ref.watch(userPostsProvider(communities)).when(
                      data: (data) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        print(error.toString());
                        return ErrorText(
                          error: error.toString(),
                        );
                      },
                      loading: () => const Loader(),
                    ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    } else {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) => ref.watch(guestPostsProvider).when(
                  data: (data) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = data[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    print(error.toString());
                    return ErrorText(
                      error: error.toString(),
                    );
                  },
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    }
  }
}
