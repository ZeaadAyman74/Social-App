import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/post_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../models/post_model.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(InitialState());

  static LayoutCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    const ChatsScreen(),
    PostScreen(),
    const UsersScreen(),
    const ProfileScreen(),
  ];

  List<Widget> titles = [
    const Text('Home'),
    const Text('Chats'),
    const Text('Post'),
    const Text('User'),
    const Text('Profile'),
  ];

  void changeBottomNavBar(int index) {
    if (index == 2) {
      emit(NewPostState());
    } else if (index == 4) {
      getMyPostsId();
      currentIndex = index;
      emit(ChangeBottomNavState());
    } else {
      currentIndex = index;
      emit(ChangeBottomNavState());
    }
  }

  UserModel? userModel;

  getUserData() async {
    emit(GetUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      userModel = UserModel.fromJson(value.data());
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState(error.toString()));
    });
  }

  List<UserModel> allUsers = [];

  getAllUsers() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      if (allUsers.length != value.docs.length) {
        allUsers = [];
        value.docs.forEach((element) {
          if (element.id != uId) {
            allUsers.add(UserModel.fromJson(element.data()));
          }
        });
        emit(GetAllUsersSuccessState());
      }
    }).catchError((error) {
      emit(GetAllUsersErrorState(error.toString()));
    });
  }

  ImagePicker picker = ImagePicker();

  File? profileImage;

  void pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PickProfileImageSuccessState());
    } else {
      emit(PickProfileImageErrorState());
    }
  }

  File? coverImage;

  void pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(PickCoverImageSuccessState());
    } else {
      emit(PickCoverImageErrorState());
    }
  }

  uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UploadProfileImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) async {
      if (kDebugMode) {
        print(value.toString());
      }
      await value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profileImage: value,
        );
      }).catchError((error) {
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState());
    });
  }

  uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UploadCoverImageLoadingState());
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) async {
      await value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, coverImage: value);
      }).catchError((error) {
        emit(UploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState());
    });
  }

  updateUser({
    required String name,
    required String phone,
    required String bio,
    String? profileImage,
    String? coverImage,
  }) async {
    emit(UserUpdateLoadingState());
    UserModel updateModel = UserModel(
      name: name,
      email: userModel!.email,
      phone: phone,
      uId: userModel!.uId,
      bio: bio,
      isEmailVerified: false,
      image: profileImage ?? userModel!.image,
      cover: coverImage ?? userModel!.cover,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(updateModel.toMap())
        .then((value) async {
      await getUserData();
      await updatePostsData(myPostsId);
      emit(UserUpdateSuccessState());
    }).catchError((error) {
      emit(UserUpdateErrorState());
    });
  }

  File? postImage;

  void pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PickPostImageSuccessState());
    } else {
      emit(PickPostImageErrorState());
    }
  }

  void clearPostImage() {
    postImage = null;
    emit(ClearPostImageState());
  }

  void uploadPostImage({
    required String text,
    required String date,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(postImage: value, date: date, text: text);
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  File? postVideo;

  pickPostVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      postVideo = File(pickedVideo.path);
      emit(PickPostVideoSuccessState());
    } else {
      emit(PickPostVideoErrorState());
    }
  }

  void clearPostVideo() {
    postVideo = null;
    emit(ClearPostImageState());
  }

  uploadPostVideo({
    required String text,
    required String date,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('videos/${Uri.file(postVideo!.path).pathSegments.last}')
        .putFile(postVideo!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(postVideo: value, date: date, text: text);
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  Future<void> createPost({
    required String date,
    required String text,
    String? postImage,
    String? postVideo,
  }) async {
    emit(CreatePostLoadingState());
    PostModel postModel = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      profileImage: userModel!.image,
      dateTime: date,
      text: text,
      postImage: postImage,
      postVideo: postVideo,
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) async {
      posts.insert(0, postModel);
      myPosts.insert(0, postModel);
      likes.insert(0, 0);
      postsId.insert(0, value.id);
      emit(CreatePostSuccessState());
      await setMyPostsId(value.id);
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  Future<void> updatePostsData(List<String> myPostsId) async {
    emit(UpdateMyPostsLoadingSate());
    try {
      myPostsId.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(element)
            .update({'image': userModel!.image, 'name': userModel!.name});
      });
      emit(UpdateMyPostsSuccessSate());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(UpdateMyPostsErrorSate());
    }
  }

  List<String> myPostsId = [];
  setMyPostsId(String myPostId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId!)
        .collection('postsId')
        .doc(myPostId)
        .set({});
  }

  void getMyPostsId() {
    myPostsId = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId!)
        .collection('postsId')
        .get()
        .then((value) {
      for (var element in value.docs) {
        myPostsId.add(element.id);
      }
      emit(GetMyPostsIdSuccessSate());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetMyPostsIdErrorSate());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int>commentsNumber=[];
  Future<void> getAllPosts() async {
    emit(GetPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      if (posts.length != value.docs.length) {
        posts = [];
        postsId = [];
        likes = [];
        commentsNumber=[];
        value.docs.forEach((element) async {
          await element.reference.collection('likes').get().then((value) {
            likes.add(value.docs.length);
            posts.add(PostModel.fromJson(element.data()));
            postsId.add(element.id);
          }).catchError((error) {});
          await element.reference.collection('comments').get().then((value){
            commentsNumber.add(value.docs.length);
          }).catchError((error){});
          if (posts.length == value.docs.length) {
            emit(GetPostsSuccessState());
          }
        });
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetPostsErrorState(error.toString()));
    });
  }

  Future<void> getAllPostsOnRefresh() async {
    emit(GetPostsLoadingState());
    posts = [];
    postsId = [];
    likes = [];
    commentsNumber=[];
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          postsId.add(element.id);
        }).catchError((error) {});
        await element.reference.collection('comments').get().then((value){
          commentsNumber.add(value.docs.length);
        }).catchError((error){});
        if (posts.length == value.docs.length) {
          emit(GetPostsSuccessState());
        }
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetPostsErrorState(error.toString()));
    });
  }

  List<PostModel> myPosts = [];
  Future<void> getMyPosts() async {
    emit(GetMyPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: userModel!.uId)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
          if(myPosts.length!=value.docs.length){
            myPosts = [];
            value.docs.forEach((element) {
              myPosts.add(PostModel.fromJson(element.data()));
              if (myPosts.length == value.docs.length) {
                emit(GetMyPostsSuccessState());
              }
            });
          }
    }).catchError((error) {
      emit(GetMyPostsErrorState());
    });
  }

  Future<void> getMyPostsOnRefresh() async {
    emit(GetMyPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: userModel!.uId)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
        myPosts = [];
        value.docs.forEach((element) {
          myPosts.add(PostModel.fromJson(element.data()));
          if (myPosts.length == value.docs.length) {
            emit(GetMyPostsSuccessState());
          }
        });

    }).catchError((error) {
      emit(GetMyPostsErrorState());
    });
  }

  void likePost(String postId, int index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId!)
        .set({
      'like': true,
    }).then((value) {
      ++likes[index];
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }

  List<CommentModel> comments = [];
  addComment(String postId, String comment) {
    emit(AddCommentLoadingState());
    CommentModel model = CommentModel(
      name: userModel!.name,
      comment: comment,
      dateTime: DateTime.now().toString(),
      profileImage: userModel!.image,
      uId: userModel!.uId,
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

  Future<void> sendMessage({
    String? text,
    String? audioMsg,
    required String receiverId,
  }) async {
    emit(SendMessageLoadingState());
    MessageModel model = MessageModel(
        text: text,
        audioMsg: audioMsg,
        receiverId: receiverId,
        senderId: userModel!.uId,
        dateTime: DateTime.now().toString());
//set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    // set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
 // Map<String, MessageModel> lastMessages = {};

  getMessages({
    required String receiverId,
  }) async {
     FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      //lastMessages.addAll({receiverId: MessageModel.fromJson(event.docs.last.data())});
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetAllMessagesSuccessState());
    });
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  int audioNum = 0;

  Future<int> getLength() async {
    ListResult storage =(await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('audios')
        .list()) ;
    return storage.items.length;
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/records";
    var newDirectory = Directory(sdPath);
    if (!newDirectory.existsSync()) {
      newDirectory.createSync(recursive: true);
    }
    audioNum = await getLength();
    return "$sdPath/test_${audioNum++}.mp3";
  }

  bool isRecording = false;
  String? recordFilePath;

  void startRecord() async {
    isRecording = true;
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath!, (type) {
        print(type.toString());
      });
    }
  }

  void stopRecord({required String receiverId}) async {
    bool stopped = RecordMp3.instance.stop();
    if (stopped) {
      isRecording = false;
      await uploadAudio(receiverId: receiverId);
    }
  }

  uploadAudio({required String receiverId}) {
    emit(UploadRecordLoadingState());
    if (recordFilePath != null) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('audios/${Uri.file(recordFilePath!).pathSegments.last}')
          .putFile(File(recordFilePath!))
          .then((value) {
        emit(UploadRecordSuccessState());
        value.ref.getDownloadURL().then((value) async {
          await sendMessage(audioMsg: value.toString(), receiverId: receiverId);
        });
      }).catchError((error) {
        emit(UploadRecordErrorState());
      });
    }
  }

// AudioPlayer audioPlayer = AudioPlayer();
// bool isPlaying = false;
// Duration duration = Duration.zero;
// Duration position = Duration.zero;
// IconData playerIcon = Icons.play_arrow;
//
// Future<void> play(String url) async {
//   isPlaying = true;
//   emit(PlayRecordState());
//   await audioPlayer.play(
//     UrlSource(url),
//   );
// }
//
// Future<void> stopPlayer() async {
//   await audioPlayer.stop().then((value) {
//     isPlaying = false;
//     emit(PlayRecordState());
//   });
// }

// getPosts() async {
//   emit(GetPostsLoadingState());
//   try{
//     QuerySnapshot<Map<String,dynamic>> post=await FirebaseFirestore.instance.collection('posts').get();
//     late QuerySnapshot like;
//     post.docs.forEach((element)async {
//       like= await element.reference.collection('likes').get();
//       likes.add(like.docs.length);
//       print('$likes  *********************');
//       posts.add(PostModel.fromJson(element.data()));
//       print('$posts ************************');
//       postsId.add(element.id);
//       print('$postsId  ****************************');
//       if(posts.length==post.docs.length) {
//         emit(GetPostsSuccessState());
//       }
//     });
//   }catch(error){
//     emit(GetPostsErrorState(error.toString()));
//   }
// }

}
