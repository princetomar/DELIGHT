import 'package:delight/core/constants/constants.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/theme/pallets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        icon: Image.asset(
          Constants.googlePath,
          width: size.width * 0.1,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: Size(double.infinity, size.height * 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
