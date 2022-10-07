import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/layout_screen.dart';
import 'package:social_app/modules/chats/chat_cubit/chat_cubit.dart';
import 'package:social_app/modules/comments/cubit/comments_cubit.dart';
import 'package:social_app/modules/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:social_app/modules/new_post/cubit/new_post_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'cubit_observer.dart';
import 'modules/login/cubit/cubit.dart';
import 'modules/login/home_login.dart';
import 'modules/user_profile/cubit/user_profile_cubit.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('on background message');
//   print(message.data.toString());
//   showToast(message: 'on background message', state: ToastStates.SUCCESS);
// }

void main() async {
  // دي عشان تتاكد ان كل حاجة هنا في الميثود خلصت و بعدين يفتح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await CacheHelper.init();
  // String? token=await FirebaseMessaging.instance.getToken();  // this is unique for the device
  // print("$token -----------------------");

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //   showToast(message: 'on message', state: ToastStates.SUCCESS);
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   print(event.data.toString());
  //   showToast(message: 'on message opened app', state: ToastStates.SUCCESS);
  //
  // });
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Widget startWidget;
  bool? isDark = CacheHelper.getData(key: 'isDark');
  uId = CacheHelper.getData(key: 'uId');
  if (uId != null) {
    startWidget = const LayoutScreen();
    if (kDebugMode) {
      print('$uId');
    }
  } else {
    startWidget = const HomeLogin();
  }
  BlocOverrides.runZoned(() => runApp(MyApp(isDark, startWidget)),
      blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  bool? isDark;
  Widget startsWidget;

  MyApp(this.isDark, this.startsWidget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LayoutCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
        BlocProvider(
            create: (context) => CommentsCubit()
        ),
        BlocProvider(create: (context)=>ProfileCubit()
        ),
        BlocProvider(create: (context)=>EditProfileCubit()),

        BlocProvider(create: (context)=>NewPostCubit()),

        BlocProvider(create: (context)=>UserProfileCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        //initialRoute: ,
        // routes:myRoutes(),
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: startsWidget,
        ),
      ),
    );
  }
}
