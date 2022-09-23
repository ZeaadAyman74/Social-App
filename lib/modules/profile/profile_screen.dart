import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import '../feeds/feeds_details.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String route='profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
  LayoutCubit.get(context).getMyPosts();
super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;
    double height=size.height;
    double width=size.width;

    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context, state) {},
        builder:(context, state) {
        var cubit=LayoutCubit.get(context);
          var model=cubit.userModel;
          return RefreshIndicator(
            key: refreshKey,
            onRefresh:()=>cubit.getMyPostsOnRefresh(),
            child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: .35*height,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Align(
                              alignment:AlignmentDirectional.topCenter,
                              child: Hero(
                                tag: 'cover',
                                child: Container(
                                  height: .26*height,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage('${model?.cover}'),
                                      fit:BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                radius:0.103*height ,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child:  CircleAvatar(
                                  radius: .1*height,
                                  backgroundImage: NetworkImage(
                                    '${model?.image}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Text(model?.name ?? " " , style: Theme.of(context).textTheme.bodyText1,overflow: TextOverflow.ellipsis,),
                      const SizedBox(height: 4,),
                      Text(model!.bio!,style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 14),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: (){},
                              child: Column(
                                children:  [
                                  Text("100",style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 18),),
                                  const SizedBox(height: 5,),
                                  Text('posts',style: Theme.of(context).textTheme.caption,)
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Column(
                                children:  [
                                  Text("200",style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 18),),
                                  const SizedBox(height: 5,),
                                  Text('photos',style: Theme.of(context).textTheme.caption,)
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Column(
                                children:  [
                                  Text("10K",style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 18),),
                                  const SizedBox(height: 5,),
                                  Text('Followers',style: Theme.of(context).textTheme.caption,)
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){},
                              child: Column(
                                children:  [
                                  Text("74",style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 18),),
                                  const SizedBox(height: 5,),
                                  Text('Followings',style: Theme.of(context).textTheme.caption,)
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15,left: 8,right: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileScreen()));
                                  },
                                  child: const Text('Edit Profile'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ConditionalBuilder(
                    condition: cubit.myPosts.isNotEmpty,
                    builder: (context) {
                      return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                               itemBuilder: (context, index) => PostItem(
                                height: height+55,
                                width: width,
                                model: cubit.myPosts[index],
                                index: index,
                              ),
                              separatorBuilder: (context, index) => SizedBox(
                                height: .025 * height,
                              ),
                              itemCount: cubit.myPosts.length);
                    },
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator(),
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
