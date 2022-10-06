import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';

class CoverImage extends StatelessWidget {
  String coverImage;
  final double height;
   CoverImage({Key? key,required this.height,required this.coverImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit,ProfileStates>(

      builder: (context, state) {
        return Align(
          alignment:AlignmentDirectional.topCenter,
          child: Container(
            height: .26*height,
            width: double.infinity,
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              image: DecorationImage(
                image: NetworkImage(coverImage),
                fit:BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
