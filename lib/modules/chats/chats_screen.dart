import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/chats/chat_item.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);
  static String route='my_chats_screen';


  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  fetchUsers() async {
    await LayoutCubit.get(context).getAllUsers();
    }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: LayoutCubit.get(context).allUsers.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) => ChatItem(LayoutCubit.get(context).allUsers[index]),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
              itemCount: LayoutCubit.get(context).allUsers.length),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
