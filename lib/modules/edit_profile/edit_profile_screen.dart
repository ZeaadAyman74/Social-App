import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import '../../models/user_model.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  static String route = 'edit_profile_screen';

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey=GlobalKey<FormState>();

  ImageProvider checkForNewProfileImage({required File? updatedProfileImage,required UserModel? model}){
    if (updatedProfileImage == null) {
      return NetworkImage('${model?.image}');
    } else {
      return FileImage(updatedProfileImage);
    }
  }
  ImageProvider checkForNewCoverImage({required File? updatedCoverImage,required UserModel? model}){
    if (updatedCoverImage == null) {
      return NetworkImage('${model?.cover}');
    } else {
      return  FileImage(updatedCoverImage);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(IconBroken.Arrow___Left)),
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: () {
                LayoutCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text);
              },
              child: const Text("UPDATE"))
        ],
      ),
      body: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {
          if(state is UserUpdateSuccessState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);
          UserModel? model = cubit.userModel;
          nameController.text = model!.name!;
          bioController.text = model.bio!;
          phoneController.text = model.phone??'write a phone number';
          File? updatedProfileImage = cubit.profileImage;
          File? updatedCoverImage = cubit.coverImage;
          ImageProvider myProfileImage=checkForNewProfileImage(updatedProfileImage: updatedProfileImage, model: model);
          ImageProvider myCoverImage=checkForNewCoverImage(updatedCoverImage: updatedCoverImage, model: model);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is UserUpdateLoadingState|| state is UploadProfileImageLoadingState|| state is UploadCoverImageLoadingState)
                      Column(
                        children: const [
                          LinearProgressIndicator(),
                          SizedBox(height: 10,),
                        ],
                      ),
                    SizedBox(
                      height: 210,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Hero(
                                  tag: 'cover',
                                  child: Container(
                                    height: 160,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                      ),
                                      image: DecorationImage(
                                        image: myCoverImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const CircleAvatar(
                                    child: Icon(IconBroken.Camera),
                                  ),
                                  onPressed: () {
                                    cubit.pickCoverImage();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Hero(
                                tag: 'profile',
                                child: CircleAvatar(
                                  radius: 62,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: myProfileImage,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const CircleAvatar(
                                  child: Icon(IconBroken.Camera),
                                ),
                                onPressed: () {
                                  cubit.pickProfileImage();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (cubit.profileImage != null || cubit.coverImage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            if (cubit.profileImage != null)
                              Expanded(
                                  child: defaultButton(
                                      txt: "UPLOAD PROFILE",
                                      radius: 10,
                                      function: () {
                                        cubit.uploadProfileImage(
                                            name: nameController.text,
                                            phone: phoneController.text,
                                            bio: bioController.text);
                                      })),
                            const SizedBox(
                              width: 15,
                            ),
                            if (cubit.coverImage != null)
                              Expanded(
                                  child: defaultButton(
                                      txt: "UPLOAD COVER",
                                      radius: 10,
                                      function: () {
                                        cubit.uploadCoverImage(
                                            name: nameController.text,
                                            phone: phoneController.text,
                                            bio: bioController.text);
                                      })),
                          ],
                        ),
                      ),
                    defaultFormField(
                        myController: nameController,
                        type: TextInputType.text,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'Enter the name';
                         }else {
                            return null;
                          }
                        },
                        label: "Name",
                        prefix: IconBroken.User),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                        myController: bioController,
                        type: TextInputType.text,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'Enter the Bio';
                          }else {
                            return null;
                          }
                        },
                        label: "Bio",
                        prefix: IconBroken.Info_Circle),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultFormField(
                        myController: phoneController,
                        type: TextInputType.text,
                        validate: (value){
                          if(value!.isEmpty){
                            return 'Enter the Phone';
                          }else {
                            return null;
                          }
                        },
                        label: "Phone",
                        prefix: IconBroken.User),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget defaultFormField({
  required TextEditingController myController,
  required TextInputType type,
  required String label,
  required IconData prefix,
  required String? Function(String? value) validate,

}) {
  var myBorder =
      const OutlineInputBorder(borderSide: BorderSide(color: defaultColor));

  return TextFormField(
    validator: validate,
    controller: myController,
    keyboardType: type,
    decoration: InputDecoration(
      border: myBorder,
      focusedBorder: myBorder,
      enabledBorder: myBorder,
      errorBorder: myBorder,
      prefixIcon: IconTheme(
          data: const IconThemeData(color: defaultColor), child: Icon(prefix)),
      hintText: label,
    ),
  );
}
