import 'package:flutter/material.dart';
import 'package:social_app/modules/chats/my_audio_message.dart';

import '../../layout/cubit/layout_cubit.dart';
import '../../models/message_model.dart';

class OtherMessage extends StatelessWidget {
  MessageModel message;
   OtherMessage(this.message,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        decoration:  BoxDecoration(
          borderRadius: const BorderRadiusDirectional.only(
            topStart:Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomEnd: Radius.circular(10),
          ),
          color: Colors.grey[300],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: message.text!=null ? Text(message.text!,style: const TextStyle(fontSize: 15,fontFamily: 'Zoz'),)
            :
        MyAudioMessage(url: message.audioMsg!),
      ),
    );
  }
}
