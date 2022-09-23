import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/feeds/comments/comment_screen.dart';
import 'package:social_app/modules/feeds/video_item.dart';
import 'package:video_player/video_player.dart';
import '../../shared/styles/icon_broken.dart';

class PostItem extends StatelessWidget {
  PostModel model;
  int index;
  double height, width;
  late final double percentage;

  PostItem({
    required this.height,
    required this.width,
    required this.model,
    required this.index,
  }) {
    percentage = height / width;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12 * percentage,
                  backgroundImage: NetworkImage('${model.profileImage}'),
                ),
                SizedBox(
                  width: .028 * width,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${model.name} ",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(fontSize: 8 * percentage),
                          ),
                          SizedBox(
                            width: .014 * width,
                          ),
                        ],
                      ),
                      SizedBox(height:.01*height ,),
                      Text(
                        DateFormat('yyyy-MM-dd hh:mm').format(DateTime.parse(model.dateTime!)),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(height: 1),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.more_horiz),
                )
              ],
            ),
            SizedBox(
              height: .033 * height,
            ),
            Container(
              margin: EdgeInsetsDirectional.only(
                  bottom: .02 * height, end: .01 * width, start: .01 * width),
              height: 1,
              color: Colors.grey[300],
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: .01 * height),
              child: Text(
                '${model.text}',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(height: .002 * height, fontSize: .044 * width),
              ),
            ),
            if (model.postImage != null)
              Container(
                height: .4 * height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                      image: NetworkImage('${model.postImage}'),
                      fit: BoxFit.cover),
                ),
              ),
            if (model.postVideo != null)
              VideoItem(
                videoPlayerController:
                    VideoPlayerController.network(model.postVideo!),
                height: height,
              ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      LayoutCubit.get(context).likePost(
                          LayoutCubit.get(context).postsId[index], index);
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 10 * percentage,
                        ),
                        SizedBox(
                          width: .01 * width,
                        ),
                        Text(
                          '${LayoutCubit.get(context).likes[index]}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      LayoutCubit.get(context)
                          .getComments(LayoutCubit.get(context).postsId[index]);
                      showModalBottomSheet(
                          builder: (context) => CommentScreen(
                              postId: LayoutCubit.get(context).postsId[index]),
                          context: context,
                          isScrollControlled: true,
                          elevation: 10,
                          shape:const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),topRight:  Radius.circular(15),
                              )
                          )
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Chat,
                          color: Colors.amber,
                          size: 10 * percentage,
                        ),
                        SizedBox(
                          width: .01 * width,
                        ),
                        Text(
                          '${LayoutCubit.get(context).commentsNumber[index]} comment',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 7, 10, 13),
              child: Container(
                height: 1,
                color: Colors.grey[300],
                width: double.infinity,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      LayoutCubit.get(context).getComments(LayoutCubit.get(context).postsId[index]);
                      Scaffold.of(context).showBottomSheet((context) =>CommentScreen(postId: LayoutCubit.get(context).postsId[index]),
                        shape:   const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                               topLeft: Radius.circular(15),topRight:  Radius.circular(15),
                             )
                           ));
                    //   showModalBottomSheet(
                    //     builder: (context) => CommentScreen(
                    //         postId: LayoutCubit.get(context).postsId[index]),
                    //     context: context,
                    //     isScrollControlled: true,
                    //     elevation: 10,
                    // shape:const RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(15),topRight:  Radius.circular(15),
                    //   )
                    // )
                    //   );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 8 * (percentage),
                          backgroundImage: NetworkImage(
                            '${LayoutCubit.get(context).userModel!.image}',
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Write a comment ...',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(fontSize: 7 * percentage),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
