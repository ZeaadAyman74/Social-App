abstract class NewPostStates {}

class NewPostInitialState extends NewPostStates {}

class PickPostImageSuccessState extends NewPostStates {}

class PickPostImageErrorState extends NewPostStates {}

class  PickPostVideoSuccessState extends NewPostStates {}

class  PickPostVideoErrorState extends NewPostStates {}

class CreatePostLoadingState extends NewPostStates {}

class CreatePostSuccessState extends NewPostStates {}

class CreatePostErrorState extends NewPostStates {}

class ClearPostImageState extends NewPostStates {}