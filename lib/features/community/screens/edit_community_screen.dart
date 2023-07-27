import 'dart:io';

import 'package:delight/core/common/error_text.dart';
import 'package:delight/core/common/loader.dart';
import 'package:delight/core/constants/constants.dart';
import 'package:delight/core/utils.dart';
import 'package:delight/features/community/controller/community_controller.dart';
import 'package:delight/models/community_model.dart';
import 'package:delight/theme/pallets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          community: community,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final size = MediaQuery.of(context).size;
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: currentTheme.backgroundColor,
            // backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text("Edit Community"),
              centerTitle: false,
              actions: [
                TextButton(
                  child: Text("Save"),
                  onPressed: () => save(community),
                )
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  // color: Pallete.darkModeAppTheme.textTheme
                                  //     .bodyText2!.color!,
                                  color:
                                      currentTheme.textTheme.bodyText2!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault
                                            ? Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: size.width * 0.12,
                                                ),
                                              )
                                            : Image.network(community.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                right: size.width / 2.53,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              FileImage(profileFile!),
                                          radius: size.height * 0.04,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(community.avatar),
                                          radius: size.height * 0.04,
                                        ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          error: (Object error, StackTrace stackTrace) =>
              ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
