import 'package:delight/core/common/loader.dart';
import 'package:delight/core/common/sign_in_button.dart';
import 'package:delight/core/constants/constants.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: size.height * 0.07,
        ),
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context),
            child: const Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Text(
                    "Find the Same Taste",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Constants.delightLoginEmote2Path,
                      height: size.height * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SignInButton(),
                ],
              ),
            ),
    );
  }
}
