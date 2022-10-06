import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';

class ChatItem extends StatelessWidget {
  UserModel user;
  bool searchItem;
   ChatItem(this.user,{Key? key,this.searchItem=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatScreen(user)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
            radius: 27,
            backgroundImage: NetworkImage(
                user.image!
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            searchItem?
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      user.name!,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(fontSize: 16,),
                    ),
                    const SizedBox(height: 5,),
                    Text(
                      '${user.bio}',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(height: 1),
                    ),
                  ],) :
                 Text(
              user.name!,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontSize: 16,),
            ),
          ],
        ),
      ),
    );

  }
}
