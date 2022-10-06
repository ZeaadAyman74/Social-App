abstract class EditProfileStates {}

class InitialState extends EditProfileStates{}

class PickProfileImageSuccessState extends EditProfileStates {}

class PickProfileImageErrorState extends EditProfileStates {}

class PickCoverImageSuccessState extends EditProfileStates {}

class PickCoverImageErrorState extends EditProfileStates {}

class UploadProfileImageLoadingState extends EditProfileStates {}

class UploadProfileImageSuccessState extends EditProfileStates {}

class UploadProfileImageErrorState extends EditProfileStates {}

class UploadCoverImageLoadingState extends EditProfileStates {}

class UploadCoverImageSuccessState extends EditProfileStates {}

class UploadCoverImageErrorState extends EditProfileStates {}

class UserUpdateLoadingState extends EditProfileStates {}

class UserUpdateSuccessState extends EditProfileStates {}

class UserUpdateErrorState extends EditProfileStates {}
