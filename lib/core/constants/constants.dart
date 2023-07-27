import 'package:delight/features/posts/screens/add_post_screen.dart';
import 'package:delight/feed/feed_Screen.dart';
import 'package:flutter/material.dart';

class Constants {
  static const logoPath = "assets/images/delight.png";
  static const logoNamePath = "assets/images/delight_name.png";
  static const delighLoginEmotePath = "assets/images/delightEmote.png";
  static const delightLoginEmote2Path = "assets/images/delightEmote2.png";
  static const loginEmotePath = "assets/images/loginEmote.png";
  static const googlePath = "assets/images/google.png";

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://img.freepik.com/premium-vector/cute-cat-gaming-icon-illustration-animal-game-icon-concept-isolated-flat-cartoon-style_138676-1271.jpg?w=1380';

  static const tabWidget = [
    FeedScreen(),
    AddPostScreen(),
  ];

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
}
