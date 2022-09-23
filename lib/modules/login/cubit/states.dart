abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangePassVisibilityState extends LoginStates{}

class RegisterLoadingState extends LoginStates {}

class RegisterSuccessState extends LoginStates {}

class RegisterErrorState extends LoginStates {
  String error;
  RegisterErrorState(this.error);
}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  String uId;
  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  String error;
  LoginErrorState({required this.error});
}

class CreateUserLoadingState extends LoginStates {}

class CreateUserSuccessState extends LoginStates {}

class CreateUserErrorState extends LoginStates {
  String error;
  CreateUserErrorState(this.error);
}

class LogoutSuccessState extends LoginStates {}