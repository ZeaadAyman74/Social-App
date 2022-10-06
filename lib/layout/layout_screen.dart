import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/new_post/post_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../modules/chats/chats_screen.dart';
import '../modules/feeds/feeds_screen.dart';
import '../modules/profile/profile_screen.dart';
import '../modules/users/users_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);
  static String route = 'layout_screen';

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {

  int _currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
     const ChatsScreen(),
    PostScreen(),
    const UsersScreen(),
    const ProfileScreen(),
  ];
  List<Widget> titles = [
    const Text('Home'),
    const Text('Chats'),
    const Text('Post'),
    const Text('User'),
    const Text('Profile'),
  ];

  _onTap(int index,BuildContext context){
    setState((){
      if(index==2){
        Navigator.push(context,MaterialPageRoute(builder: (_)=>PostScreen()));
      }else{
        _currentIndex=index;
      }

    });
  }

  void fetchData() async {
    await LayoutCubit.get(context).getUserData();
    await LayoutCubit.get(context).getAllPosts();
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
        return Scaffold(
          appBar: AppBar(
            title: titles[_currentIndex],
            actions: [
              const Icon(IconBroken.Notification),
              SizedBox(
                width: .01 * width,
              ),
              IconButton(
                icon: const Icon(IconBroken.Search),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()));
                },
              ),
              SizedBox(
                width: .008 * width,
              ),
            ],
          ),
          body: screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                _onTap(index,context);
              },
              items: const[
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.Chat),
                  label: "Chats",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.Paper_Upload),
                  label: "Post",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.User1),
                  label: "Users",
                ),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Profile), label: "Profile"),
              ]),
        );
  }
}
