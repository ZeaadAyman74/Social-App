import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/new_post/cubit/new_post_states.dart';
import '../../../models/post_model.dart';
import '../../profile/cubit/profile_cubit.dart';
import '../../profile/cubit/profile_states.dart';

class NewPostCubit extends Cubit<NewPostStates>{
  NewPostCubit():super(NewPostInitialState());

  static NewPostCubit get(BuildContext context)=>BlocProvider.of(context);

  File? postImage;
  void pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PickPostImageSuccessState());
    } else {
      emit(PickPostImageErrorState());
    }
  }

  void clearPostImage() {
    postImage = null;
    emit(ClearPostImageState());
  }

  void uploadPostImage({
    required BuildContext context,
    required String text,
    required String date,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(postImage: value, date: date, text: text, context: context);
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  ImagePicker picker = ImagePicker();
  File? postVideo;
  pickPostVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      postVideo = File(pickedVideo.path);
      emit(PickPostVideoSuccessState());
    } else {
      emit(PickPostVideoErrorState());
    }
  }

  void clearPostVideo() {
    postVideo = null;
    emit(ClearPostImageState());
  }

  uploadPostVideo({
    required BuildContext context,
    required String text,
    required String date,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('videos/${Uri.file(postVideo!.path).pathSegments.last}')
        .putFile(postVideo!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(postVideo: value, date: date, text: text, context: context);
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  Future<void> createPost({
    required BuildContext context,
    required String date,
    required String text,
    String? postImage,
    String? postVideo,
  }) async {
    emit(CreatePostLoadingState());
    var homeCubit=LayoutCubit.get(context);
    PostModel postModel = PostModel(
      name: homeCubit.userModel!.name,
      uId: homeCubit.userModel!.uId,
      profileImage:homeCubit.userModel!.image,
      dateTime: date,
      text: text,
      postImage: postImage,
      postVideo: postVideo,
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) async {
      homeCubit.posts.insert(0, postModel);
      ProfileCubit.get(context).myPosts.insert(0, postModel);
     homeCubit.likes.insert(0, 0);
     homeCubit.postsId.insert(0, value.id);
     ProfileCubit.get(context).emit(MyPostCreatedState());
     homeCubit.emit(NewPostCreatedState());
      emit(CreatePostSuccessState());
      await homeCubit.setMyPostsId(value.id);
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }
}