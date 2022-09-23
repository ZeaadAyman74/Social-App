import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/feeds/video_item.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:video_player/video_player.dart';

class PostScreen extends StatelessWidget {
   PostScreen({Key? key}) : super(key: key);
   static String route='new_post_screen';


   var postController=TextEditingController();
   VideoPlayerController? _videoController;

  @override
  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;
    double _screenHeight=size.height;
    double _screenWidth=size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: () {
              if(LayoutCubit.get(context).postImage==null&&LayoutCubit.get(context).postVideo==null){
                LayoutCubit.get(context).createPost( date:DateTime.now().toString() , text: postController.text);
              }else if (LayoutCubit.get(context).postVideo==null){
                LayoutCubit.get(context).uploadPostImage(text: postController.text, date: DateTime.now().toString());
              }else{
                LayoutCubit.get(context).uploadPostVideo(text: postController.text, date: DateTime.now().toString());
              }
              },
            style:ButtonStyle(overlayColor:MaterialStateProperty.all(Colors.white) ),
            child: const Text(
              "Post",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      body: BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context, state) {
          if(state is CreatePostSuccessState){
            Navigator.pop(context);
          }
        },
      builder: (context, state) {
          var cubit=LayoutCubit.get(context);
          if(cubit.postVideo!=null){
            _videoController= VideoPlayerController.file(cubit.postVideo!);
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(state is CreatePostLoadingState )
                  const LinearProgressIndicator(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     CircleAvatar(
                      radius: 27,
                      backgroundImage: NetworkImage(
                        '${LayoutCubit.get(context).userModel!.image}',
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${LayoutCubit.get(context).userModel!.name}',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(fontSize: 16),
                      textAlign:TextAlign.center ,
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: postController,
                    decoration: const InputDecoration(
                      hintText: "what is on your mind...",
                      border: InputBorder.none,

                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
                if(cubit.postImage!=null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: _screenHeight*.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(cubit.postImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        child: Icon(IconBroken.Close_Square),
                      ),
                      onPressed: () {
                        cubit.clearPostImage();
                      },
                    ),
                  ],
                ),
                if(cubit.postVideo!=null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                       SizedBox(
                        height: _screenHeight*.25,
                        width: double.infinity,
                        child: VideoItem(height:_screenHeight ,videoPlayerController:_videoController! ,)
                      ),
                      IconButton(
                        icon: const CircleAvatar(
                          child: Icon(IconBroken.Close_Square),
                        ),
                        onPressed: () {
                          cubit.clearPostVideo();
                        },
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(onPressed: (){
                      cubit.pickPostImage();
                    }, child: Row(
                      children: const [
                        Icon(IconBroken.Image),
                        SizedBox(width: 10,),
                        Text('Add Photo'),
                      ],
                    ),
                    ),
                    TextButton(onPressed: (){
                      cubit.pickPostVideo();
                    }, child: Row(
                      children: const [
                        Text('Add Video'),
                      ],
                    ),
                    ),
                  ],),
              ],
            ),
          );
      },
      )

    );
  }
}
