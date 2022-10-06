import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:social_app/modules/chats/chat_cubit/chat_states.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/components/constants.dart';

class ChatCubit extends Cubit<ChatStates>{
  ChatCubit():super(InitialState());
  static ChatCubit get(BuildContext context) => BlocProvider.of(context);

  List<UserModel> allUsers = [];
 Future<void> getAllUsers() async {
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
        senderId:uId,
        dateTime: DateTime.now().toString());
//set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
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
        .doc(uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  getMessages({
    required String receiverId,
  }) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
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

}