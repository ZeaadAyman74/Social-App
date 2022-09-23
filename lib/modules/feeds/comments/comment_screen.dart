import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/feeds/comments/comment_item.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/icon_broken.dart';

class CommentScreen extends StatelessWidget {
  String postId;
   CommentScreen({Key? key,required this.postId}) : super(key: key);
   

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    final height=size.height;
    final width=size.width;

    var controller=TextEditingController();
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=LayoutCubit.get(context);
            return Padding(
              padding: EdgeInsets.only(top: 8,  right: 8,  left: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: height*.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConditionalBuilder(
                      condition: cubit.comments.isNotEmpty,
                      builder:(context){
                        return Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => CommentItem(model: cubit.comments[index],height: height,width: width),
                              separatorBuilder:(context, index) =>const SizedBox(height: 20,),
                              itemCount: LayoutCubit.get(context).comments.length),
                        );
                      },
                      fallback:(context)=> const Center(child: Text('No Comments'),),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 1,

                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
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
                                borderRadius:  BorderRadius.all(
                                  Radius.circular(5*height/width),
                                ),
                              ),
                              child: TextFormField(
                                controller: controller,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'write a comment..',
                                  contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  hintStyle: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsetsDirectional.only(start: 5, end: 0),
                            child: Container(
                              height: .066*height,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: const BoxDecoration(
                                color: defaultColor,
                                shape: BoxShape.circle,
                              ),
                              child: MaterialButton(
                                splashColor: Colors.transparent,
                                minWidth: 1,
                                onPressed: () {
                                  cubit.addComment(postId, controller.text);
                                  controller.clear();
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
              ),
            );
      },
    );
  }
}
