abstract class CommentsStates {}

class InitialState extends CommentsStates {}

class AddCommentLoadingState extends CommentsStates {}

class AddCommentSuccessState extends CommentsStates {}

class AddCommentErrorState extends CommentsStates {}

class GetCommentsLoadingState extends CommentsStates {}

class GetCommentsSuccessState extends CommentsStates {}

class GetCommentsErrorState extends CommentsStates {}