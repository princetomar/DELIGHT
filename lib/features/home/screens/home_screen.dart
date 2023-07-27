import 'package:delight/core/constants/constants.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/features/home/delegates/search_community_delegate.dart';
import 'package:delight/features/home/drawers/community_list_drawer.dart';
import 'package:delight/features/home/drawers/profile_drawer.dart';
import 'package:delight/theme/pallets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  // To display the right drawer
  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchCommunityDelegate(ref: ref),
              );
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          })
        ],
      ),
      drawer: CommunityListDrawer(),
      body: Constants.tabWidget[_page],
      endDrawer: isGuest == true ? null : ProfileDrawer(),
      bottomNavigationBar: isGuest
          ? null
          : CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.backgroundColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: "",
                ),
              ],
              onTap: onPageChange,
              currentIndex: _page,
            ),
    );
  }
}
