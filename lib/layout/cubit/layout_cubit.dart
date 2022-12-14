import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/constants.dart';
import '../../models/post_model.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(BuildContext context) => BlocProvider.of(context);

  UserModel? userModel;
  getMyData() async {
    emit(GetUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      userModel = UserModel.fromJson(value.data());
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }
  
  setMyPostsId(String myPostId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId!)
        .collection('postsId')
        .doc(myPostId)
        .set({});
  }
  
  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int>commentsNumber=[];
  Future<void> getAllPosts() async {
    emit(GetPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      if (posts.length != value.docs.length) {
        posts = [];
        postsId = [];
        likes = [];
        commentsNumber=[];
        value.docs.forEach((element) async {
          await element.reference.collection('likes').get().then((value) {
            likes.add(value.docs.length);
            posts.add(PostModel.fromJson(element.data()));
            postsId.add(element.id);
          }).catchError((error) {});
          await element.reference.collection('comments').get().then((value){
            commentsNumber.add(value.docs.length);
          }).catchError((error){});
          if (posts.length == value.docs.length) {
            emit(GetPostsSuccessState());
          }
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetPostsErrorState(error.toString()));
    });
  }
  Future<void> getAllPostsOnRefresh() async {
    emit(GetPostsLoadingState());
    posts = [];
    postsId = [];
    likes = [];
    commentsNumber=[];
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          postsId.add(element.id);
        }).catchError((error) {});
        await element.reference.collection('comments').get().then((value){
          commentsNumber.add(value.docs.length);
        }).catchError((error){});
        if (posts.length == value.docs.length) {
          emit(GetPostsSuccessState());
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId, int index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId!)
        .set({
      'like': true,
    }).then((value) {
      ++likes[index];
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }


}
