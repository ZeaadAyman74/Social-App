import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/chats/chat_cubit/chat_cubit.dart';
import 'package:social_app/modules/chats/chat_cubit/chat_states.dart';
import 'package:social_app/modules/chats/components/chat_item.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);
  static String route='my_chats_screen';


  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  fetchUsers() async {
    await ChatCubit.get(context).getAllUsers();
    }

  @override
  void initState() {
    fetchUsers();
    print("fetch user /////////////////////////////");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatStates>(
      buildWhen: (previous, current) => (current is GetAllUsersSuccessState),
      builder: (context, state) {
        var cubit=ChatCubit.get(context);
        print("Chats Screen");
        return ConditionalBuilder(
          condition: cubit.allUsers.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) => ChatItem(ChatCubit.get(context).allUsers[index]),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
              itemCount:cubit.allUsers.length),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
