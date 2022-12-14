import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_cubit/chat_cubit.dart';
import 'package:social_app/modules/chats/chat_cubit/chat_states.dart';
import 'package:social_app/modules/chats/components/my_message.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/colors.dart';
import 'components/other_message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.receiverPersonModel, {Key? key}) : super(key: key);
  static const String route = 'chat_screen';
  UserModel receiverPersonModel;
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    ChatCubit.get(context).getMessages(receiverId: receiverPersonModel.uId!);
    return BlocListener<ChatCubit, ChatStates>(
      listener: (context, state) {
        if (state is SendMessageLoadingState) {
          controller.clear();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 10 * (height / width),
                backgroundImage: NetworkImage(receiverPersonModel.image!),
              ),
              SizedBox(
                width: .028 * width,
              ),
              Text(
                receiverPersonModel.name!,
                style: TextStyle(fontSize: 10 * (height / width)),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatCubit,ChatStates>(
          builder: (context, state) {
            var cubit = ChatCubit.get(context);
            print("Chat Screen");
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ConditionalBuilder(
                      condition: cubit.messages.isNotEmpty,
                      builder: (context) => Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (cubit.messages[index].senderId == uId) {
                                  return MyMessage(cubit.messages[index]);
                                }
                                return OtherMessage(cubit.messages[index]);
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: .02 * height,
                              ),
                              itemCount: cubit.messages.length,
                            ),
                          ),
                      fallback: (context) {
                        return const Center(child: Text("No Messages Yet"),
                        );
                      }),
                  SizedBox(
                    height: .07 * height,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5 * height / width),
                              ),
                            ),
                            child: TextFormField(
                              controller: controller,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Message',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                hintStyle: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: .09 * height,
                            margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: cubit.isRecording
                                      ? Colors.white
                                      : Colors.black12,
                                  spreadRadius: 5)
                            ], color: defaultColor, shape: BoxShape.circle),
                            child: GestureDetector(
                              onLongPress: () {
                                cubit.startRecord();
                              },
                              onLongPressEnd: (details) {
                                cubit.stopRecord(
                                    receiverId: receiverPersonModel.uId!);
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: 10 * (height / width),
                                  )),
                            )),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 5, end: 0),
                          child: Container(
                            height: .066 * height,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                              color: defaultColor,
                              shape: BoxShape.circle,
                            ),
                            child: MaterialButton(
                              splashColor: Colors.transparent,
                              minWidth: 1,
                              onPressed: () {
                                cubit.sendMessage(
                                  text: controller.text,
                                  receiverId: receiverPersonModel.uId!,
                                );
                              },
                              child: const Icon(
                                IconBroken.Send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
