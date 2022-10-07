import 'package:flutter/material.dart';
import 'package:social_app/modules/user_profile/users_profile_screen.dart';

import '../../models/user_model.dart';

class UserItem extends StatelessWidget {
  final UserModel user;
 const UserItem(this.user,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>UsersProfileScreen( user: user,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Hero(
              tag: 'userImage',
              child: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(
                    user.image!
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
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
              ],)
          ],
        ),
      ),
    );

  }
}
