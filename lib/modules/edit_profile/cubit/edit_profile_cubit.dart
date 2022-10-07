import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/modules/edit_profile/cubit/edit_profile_states.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import '../../../models/user_model.dart';

class EditProfileCubit extends Cubit<EditProfileStates>{
  EditProfileCubit():super(InitialState());

  static EditProfileCubit get(BuildContext context)=>BlocProvider.of(context);

  ImagePicker picker = ImagePicker();
  File? profileImage;
  void pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PickProfileImageSuccessState());
    } else {
      emit(PickProfileImageErrorState());
    }
  }

  File? coverImage;
  void pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(PickCoverImageSuccessState());
    } else {
      emit(PickCoverImageErrorState());
    }
  }

  uploadProfileImage({
    required BuildContext context,
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UploadProfileImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) async {
      if (kDebugMode) {
        print(value.toString());
      }
      await value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profileImage: value,
          context: context,
        );
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  uploadCoverImage({
    required BuildContext context,
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UploadCoverImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, coverImage: value, context: context);
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  updateUser({
    required BuildContext context,
    required String name,
    required String phone,
    required String bio,
    String? profileImage,
    String? coverImage,
  }) async {
    emit(UserUpdateLoadingState());
    UserModel updateModel = UserModel(
      name: name,
      email: LayoutCubit.get(context).userModel!.email,
      phone: phone,
      uId: LayoutCubit.get(context).userModel!.uId,
      bio: bio,
      isEmailVerified: false,
      image: profileImage ?? LayoutCubit.get(context).userModel!.image,
      cover: coverImage ?? LayoutCubit.get(context).userModel!.cover,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(LayoutCubit.get(context).userModel!.uId)
        .update(updateModel.toMap())
        .then((value)async{
      await LayoutCubit.get(context).getMyData();
      await ProfileCubit.get(context).updatePostsData(context);
      emit(UserUpdateSuccessState());
    }).catchError((error) {
      emit(UserUpdateErrorState());
    });
  }

}