abstract class ChatStates {}

class InitialState extends ChatStates {}

class GetAllUsersLoadingState extends ChatStates {}

class GetAllUsersSuccessState extends ChatStates {

}

class GetAllUsersErrorState extends ChatStates {
  String error;
  GetAllUsersErrorState(this.error);
}

class SendMessageLoadingState extends ChatStates {}

class SendMessageSuccessState extends ChatStates {}

class SendMessageErrorState extends ChatStates {}

class GetAllMessagesSuccessState extends ChatStates {}

class UploadRecordLoadingState extends ChatStates {}

class UploadRecordSuccessState extends ChatStates {}

class UploadRecordErrorState extends ChatStates {}

class PlayRecordState extends ChatStates {}

// class GetAllMessageErrorState extends LayoutStates {} // مش هحتاج ال error لان ال stream مش هيديني error لو مجبش داتا
