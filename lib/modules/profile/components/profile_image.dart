import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';

class ProfileImage extends StatelessWidget {
  String profileImage;
 final double height;
   ProfileImage({Key? key,required this.height,required this.profileImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<LayoutCubit,LayoutStates>(
      builder: (context, state) {
        return CircleAvatar(
          radius:0.103*height ,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child:  CircleAvatar(
            radius: .1*height,
            backgroundImage: NetworkImage(profileImage,),
          ),
        );
      },
    );
  }
}
