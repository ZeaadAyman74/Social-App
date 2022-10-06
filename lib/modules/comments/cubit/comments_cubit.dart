import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/modules/comments/cubit/comments_states.dart';
import '../../../models/comment_model.dart';

class CommentsCubit extends Cubit<CommentsStates>{
  CommentsCubit():super(InitialState());

  static CommentsCubit get(BuildContext context)=>BlocProvider.of(context);

  List<CommentModel> comments = [];
  addComment(String postId, String comment,BuildContext context) {
    emit(AddCommentLoadingState());
    CommentModel model = CommentModel(
      name:LayoutCubit.get(context).userModel!.name,
      comment: comment,
      dateTime: DateTime.now().toString(),
      profileImage: LayoutCubit.get(context).userModel!.image,
      uId:LayoutCubit.get(context).userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      comments.add(model);
      emit(AddCommentSuccessState());
    }).catchError((error) {
      emit(AddCommentErrorState());
    });
  }

  getComments(String postId) {
    emit(GetCommentsLoadingState());
    comments=[];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
      });
      emit(GetCommentsSuccessState());
    }).catchError((error) {
      emit(GetCommentsErrorState());
    });
  }

}