import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/cubit/social_states.dart';
import '../../layout/layout_screen.dart';
import '../network/local/cache_helper.dart';


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() :super(InitialState());

  static SocialCubit get(BuildContext context) => BlocProvider.of(context);

  bool isDark = true;

  void changeMode({bool? isDark}) {
    if (isDark != null) {
      this.isDark = isDark;
      emit(ChangeModeSuccessState());
    }else{
      CacheHelper.putData(key:'isDark', value: !this.isDark).then((value) {
        this.isDark=!this.isDark;
        emit(ChangeModeSuccessState());
      }).catchError((error){
        emit(ChangeModeErrorState());
      });

    }

  }

  // handleAuthState(){
  //   return StreamBuilder(
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (context,snapShot){
  //       if(snapShot.hasData){
  //         return const LayoutScreen();
  //       }else{
  //         return LoginScreen();
  //       }
  //       }
  //   );
  // }
}
