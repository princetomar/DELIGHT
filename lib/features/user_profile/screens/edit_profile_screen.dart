import 'dart:io';

import 'package:delight/core/common/error_text.dart';
import 'package:delight/core/common/loader.dart';
import 'package:delight/core/constants/constants.dart';
import 'package:delight/core/utils.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/features/user_profile/controller/user_profile_controller.dart';
import 'package:delight/theme/pallets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

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

  void save() {
    ref.read(userProfileControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        name: nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final size = MediaQuery.of(context).size;
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: currentTheme.backgroundColor,
            // backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text("Edit Profile"),
              centerTitle: false,
              actions: [
                TextButton(
                  child: Text("Save"),
                  onPressed: save,
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
                                        : user.banner.isEmpty ||
                                                user.banner ==
                                                    Constants.bannerDefault
                                            ? Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: size.width * 0.12,
                                                ),
                                              )
                                            : Image.network(user.banner),
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
                                              NetworkImage(user.profilePic),
                                          radius: size.height * 0.04,
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "Name",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(18),
                          ),
                        ),
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
