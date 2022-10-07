import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/user_profile/cubit/user_profile_states.dart';


class UserProfileCubit extends Cubit<UserProfileStates>{
  UserProfileCubit():super(UserInitialState());

  static UserProfileCubit get(BuildContext context)=>BlocProvider.of(context);


  List<PostModel>userPosts=[];
  Future<void>getUserPosts(String uId)async {
    emit(GetUserPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo:uId)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      userPosts = [];
        value.docs.forEach((element) {
          userPosts.add(PostModel.fromJson(element.data()));
          if (userPosts.length == value.docs.length) {
            emit(GetUserPostsSuccessState());
          }
        });
    }).catchError((error) {
      emit(GetUserPostsErrorState());
    });
  }



}