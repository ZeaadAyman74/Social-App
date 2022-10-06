import 'package:flutter/material.dart';
import '../../../models/message_model.dart';
import 'my_audio_message.dart';

class MyMessage extends StatelessWidget {
  MessageModel message;

  MyMessage(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            bottomStart: Radius.circular(10),
          ),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
                end: Alignment.centerRight,
            colors: [
              Colors.purpleAccent[400]!.withOpacity(.6),
              Colors.deepPurple.withOpacity(.6),
            ],
          ),
        //  color: Colors.blue.withOpacity(.5),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: message.text != null ? Text(message.text!,
          style: const TextStyle(fontSize: 15, fontFamily: 'Zoz'),)
              :
        MyAudioMessage(url: message.audioMsg!),
      ),
    );
  }
}
