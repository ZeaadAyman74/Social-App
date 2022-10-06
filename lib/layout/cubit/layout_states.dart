abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}

class GetUserLoadingState extends LayoutStates {}

class GetUserSuccessState extends LayoutStates {}

class GetUserErrorState extends LayoutStates {
  String error;
  GetUserErrorState(this.error);
}

class GetPostsLoadingState extends LayoutStates {}

class GetPostsSuccessState extends LayoutStates {}

class GetPostsErrorState extends LayoutStates {
  String error;
  GetPostsErrorState(this.error);
}

class NewPostCreatedState extends LayoutStates {}

class LikePostSuccessState extends LayoutStates {}

class LikePostErrorState extends LayoutStates {}


