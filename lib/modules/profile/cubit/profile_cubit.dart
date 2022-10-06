import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import '../../../models/post_model.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() :super(InitialState());

  static ProfileCubit get(BuildContext context) => BlocProvider.of(context);

  List<PostModel> myPosts = [];
  List<String> myPostsId = [];

  Future<void> getMyPosts(BuildContext context) async {
    emit(GetMyPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: LayoutCubit
        .get(context)
        .userModel!
        .uId)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      if (myPosts.length != value.docs.length) {
        myPosts = [];
        value.docs.forEach((element) {
          myPosts.add(PostModel.fromJson(element.data()));
          if (myPosts.length == value.docs.length) {
            emit(GetMyPostsSuccessState());
          }
        });
      }
    }).catchError((error) {
      emit(GetMyPostsErrorState());
    });
  }

  Future<void> getMyPostsOnRefresh(BuildContext context) async {
    emit(GetMyPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: LayoutCubit
        .get(context)
        .userModel!
        .uId)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      myPosts = [];
      value.docs.forEach((element) {
        myPosts.add(PostModel.fromJson(element.data()));
        if (myPosts.length == value.docs.length) {
          emit(GetMyPostsSuccessState());
        }
      });
    }).catchError((error) {
      emit(GetMyPostsErrorState());
    });
  }

  Future<void> getMyPostsId(BuildContext context) async {
    myPostsId = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(LayoutCubit
        .get(context)
        .userModel!
        .uId!)
        .collection('postsId')
        .get()
        .then((value) {
      for (var element in value.docs) {
        myPostsId.add(element.id);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetMyPostsIdErrorSate());
    });
  }

  Future<void> updatePostsData(BuildContext context) async {
    emit(UpdateMyPostsLoadingSate());
    try {
      CollectionReference postsCollection=FirebaseFirestore.instance.collection('posts');
      await postsCollection.where(
          'uId', isEqualTo: LayoutCubit
          .get(context)
          .userModel!
          .uId).get().then((value){
            value.docs.forEach((element) async{
              await postsCollection.doc(element.id).update({'image': LayoutCubit.get(context).userModel!.image, 'name': LayoutCubit.get(context).userModel!.name});
            });
      });
     await ProfileCubit.get(context).getMyPostsOnRefresh(context);
      // emit(UpdateMyPostsSuccessSate());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(UpdateMyPostsErrorSate());
    }
  }

}

