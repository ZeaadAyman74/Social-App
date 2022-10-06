import 'package:flutter/material.dart';
import '../../../models/comment_model.dart';

class CommentItem extends StatelessWidget {
  CommentModel model;
 late double height,width,percentage;
   CommentItem({Key? key,required this.model,required this.height,required this.width}) : super(key: key){
     percentage=height/width;
   }

  @override
  Widget build(BuildContext context) {
     return Row(
          children: [
            CircleAvatar(
              radius: 12*percentage,
              backgroundImage: NetworkImage(
                  '${model.profileImage}'
              ),
            ),
            SizedBox(
              width: .028*width,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.name} ",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontSize: 8*percentage),
                  ),
                  Text(
                    '${model.comment}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        );
  }
}
