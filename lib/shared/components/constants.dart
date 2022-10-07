import 'package:flutter/material.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import '../../layout/layout_screen.dart';
import '../../modules/chats/chats_screen.dart';
import '../../modules/edit_profile/edit_profile_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/notifications/notifications_screen.dart';
import '../../modules/users/users_screen.dart';

String? token;

late final String? uId;

Map<String,Widget Function(BuildContext)> myRoutes(){
  return {
   // LoginScreen.route:(context)=>LoginScreen(),
  //  RegisterScreen.route:(context)=>RegisterScreen(),
    LayoutScreen.route:(context)=>const LayoutScreen(),
    ProfileScreen.route:(context)=>const ProfileScreen(),
    EditProfileScreen.route:(context)=>EditProfileScreen(),
   // PostScreen.route:(context)=>LoginScreen(),
    NotificationsScreen.route:(context)=>const NotificationsScreen(),
    //SearchScreen.route:(context)=> SearchScreen(),
    UsersScreen.route:(context)=>const UsersScreen(),
    FeedsScreen.route:(context)=> FeedsScreen(),
    ChatsScreen.route:(context)=> const ChatsScreen(),
  };
}

