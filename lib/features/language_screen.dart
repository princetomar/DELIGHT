// import 'package:delight/core/common/loader.dart';
// import 'package:delight/core/common/sign_in_button.dart';
// import 'package:delight/core/constants/constants.dart';
// import 'package:delight/features/auth/controllers/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LanguageSelectionScreen extends StatefulWidget {
//   const LanguageSelectionScreen({super.key});

//   @override
//   State<LanguageSelectionScreen> createState() =>
//       _LanguageSelectionScreenState();
// }

// class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
//   void signInAsGuest(WidgetRef ref, BuildContext context) {
//     ref.read(authControllerProvider.notifier).signInAsGuest(context);
//   }

//   String language = "en";

//   @override
//   void initState() {
//     // TODO: implement initState
//     print(language);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     var items = [
//       'en',
//       'hi',
//       'es',
//       'ds',
//       'fr',
//       'gu',
//       'kn',
//       'ur',
//       'ta',
//       'tw',
//     ];
//     Map<String, String> languageMap = {
//       'English': 'en',
//       'Hindi': 'hi',
//       'Spanish': 'es',
//       'Danish': 'da',
//       'French': 'fr',
//       'Gujurati': 'gu',
//       'Kannada': 'kn',
//       'Urdu': 'ur',
//       'Tamil': 'ta',
//       'Telugu': 'te',
//     };
//     List<DropdownMenuItem<String>> get dropdownItems{
//   List<DropdownMenuItem<String>> menuItems = [
//     DropdownMenuItem(child: Text("USA"),value: "USA"),
//     DropdownMenuItem(child: Text("Canada"),value: "Canada"),
//     DropdownMenuItem(child: Text("Brazil"),value: "Brazil"),
//     DropdownMenuItem(child: Text("England"),value: "England"),
//   ];
//   return menuItems;
// }
//     String dropdownvalue = 'en';

//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Image.asset(
//             Constants.logoPath,
//             height: size.height * 0.07,
//           ),
//         ),
//       ),
//       body: Container(
//         alignment: Alignment.center,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             Text(
//               "Select Your Preferable Language",
//               style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 0.5),
//             ),
//             SizedBox(
//               height: size.height * 0.03,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.asset(
//                 Constants.delightLoginEmote2Path,
//                 height: size.height * 0.4,
//               ),
//             ),
//             SizedBox(
//               height: size.height * 0.02,
//             ),
//             Text(
//               "We will use this language to communicate with you".toUpperCase(),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 0.5),
//             ),
//             SizedBox(
//               height: size.height * 0.02,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(
//                   color: Colors.grey,
//                 ),
//               ),
//               child: 
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
