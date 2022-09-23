import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/new_post/post_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);
  static String route = 'layout_screen';

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
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

    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {
        if (state is NewPostState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PostScreen()));
        }
      },
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: cubit.titles[cubit.currentIndex],
            actions: [
              const Icon(IconBroken.Notification),
              SizedBox(
                width: .01 * width,
              ),
              IconButton(
                icon: const Icon(IconBroken.Search),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
              ),
              SizedBox(
                width: .008 * width,
              ),
            ],
          ),
          body: IndexedStack(
            index: cubit.currentIndex,
            children: cubit.screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavBar(index);
              },
              items: const [
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
      },
    );
  }
}
