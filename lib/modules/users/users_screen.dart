import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/login/home_login.dart';
import 'package:social_app/modules/login/login_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);
  static String route='users_screen';


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit,LoginStates>(
      listener: (context, state) {
        if(state is LogoutSuccessState){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLogin()));
        }
      },
      builder: (context, state) {
        return Center(
          child: MaterialButton(onPressed: () async{
      await LoginCubit.get(context).logout();
          },
            child: const Text("LOGOUT"),
          ),
        );
      },
    );
  }
}
