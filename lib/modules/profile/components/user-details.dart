import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import '../cubit/profile_states.dart';

class UserDetails extends StatelessWidget {
  String name;
  String bio;
   UserDetails({Key? key,required this.name,required this.bio}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BlocBuilder<ProfileCubit,ProfileStates>(
      builder: (context, state) {
        return Column(
          children: [
            Text(name, style: Theme.of(context).textTheme.bodyText1,overflow: TextOverflow.ellipsis,),
            const SizedBox(height: 4,),
            Text(bio,style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 14),),
          ],
        );
      },
    );
  }
}
