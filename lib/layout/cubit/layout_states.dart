abstract class LayoutStates {}

class InitialState extends LayoutStates {}

class GetUserLoadingState extends LayoutStates {}

class GetUserSuccessState extends LayoutStates {}

class GetUserErrorState extends LayoutStates {
  String error;
  GetUserErrorState(this.error);
}

class GetAllUsersLoadingState extends LayoutStates {}

class GetAllUsersSuccessState extends LayoutStates {}

class GetAllUsersErrorState extends LayoutStates {
  String error;
  GetAllUsersErrorState(this.error);
}

class ChangeBottomNavState extends LayoutStates {}

class NewPostState extends LayoutStates {}

class PickProfileImageSuccessState extends LayoutStates {}

class PickProfileImageErrorState extends LayoutStates {}

class PickCoverImageSuccessState extends LayoutStates {}

class PickCoverImageErrorState extends LayoutStates {}

class UploadProfileImageLoadingState extends LayoutStates {}

class UploadProfileImageSuccessState extends LayoutStates {}

class UploadProfileImageErrorState extends LayoutStates {}

class UploadCoverImageLoadingState extends LayoutStates {}

class UploadCoverImageSuccessState extends LayoutStates {}

class UploadCoverImageErrorState extends LayoutStates {}

class UserUpdateLoadingState extends LayoutStates {}

class UserUpdateSuccessState extends LayoutStates {}

class UserUpdateErrorState extends LayoutStates {}


// post

class PickPostImageSuccessState extends LayoutStates {}

class PickPostImageErrorState extends LayoutStates {}

class  PickPostVideoSuccessState extends LayoutStates {}

class  PickPostVideoErrorState extends LayoutStates {}

class CreatePostLoadingState extends LayoutStates {}

class CreatePostSuccessState extends LayoutStates {}

class CreatePostErrorState extends LayoutStates {}

class ClearPostImageState extends LayoutStates {}

class GetPostsLoadingState extends LayoutStates {}

class GetPostsSuccessState extends LayoutStates {}

class GetPostsErrorState extends LayoutStates {
  String error;
  GetPostsErrorState(this.error);
}

class GetMyPostsLoadingState extends LayoutStates {}

class GetMyPostsSuccessState extends LayoutStates {}

class GetMyPostsErrorState extends LayoutStates {}

class UpdateMyPostsLoadingSate extends LayoutStates {}

class UpdateMyPostsSuccessSate extends LayoutStates {}

class UpdateMyPostsErrorSate extends LayoutStates {}

class GetMyPostsIdSuccessSate extends LayoutStates {}

class GetMyPostsIdErrorSate extends LayoutStates {}

class LikePostSuccessState extends LayoutStates {}

class LikePostErrorState extends LayoutStates {}

class AddCommentLoadingState extends LayoutStates {}

class AddCommentSuccessState extends LayoutStates {}

class AddCommentErrorState extends LayoutStates {}

class GetCommentsLoadingState extends LayoutStates {}

class GetCommentsSuccessState extends LayoutStates {}

class GetCommentsErrorState extends LayoutStates {}


//Messages

class SendMessageLoadingState extends LayoutStates {}

class SendMessageSuccessState extends LayoutStates {}

class SendMessageErrorState extends LayoutStates {}

class GetAllMessagesSuccessState extends LayoutStates {}

class UploadRecordLoadingState extends LayoutStates {}

class UploadRecordSuccessState extends LayoutStates {}

class UploadRecordErrorState extends LayoutStates {}

class PlayRecordState extends LayoutStates {}

// class GetAllMessageErrorState extends LayoutStates {} // مش هحتاج ال error لان ال stream مش هيديني error لو مجبش داتا
