abstract class UserProfileStates {}
class UserInitialState extends UserProfileStates {}

class GetUserPostsLoadingState extends UserProfileStates {}

class GetUserPostsSuccessState extends UserProfileStates {}

class GetUserPostsErrorState extends UserProfileStates {}

class GetUserDataLoadingState extends UserProfileStates {}

class GetUserDataSuccessState extends UserProfileStates {}

class GetUserDataErrorState extends UserProfileStates {
  String errorMessage;
  GetUserDataErrorState(this.errorMessage);
}