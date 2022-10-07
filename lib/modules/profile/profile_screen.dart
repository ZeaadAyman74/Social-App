import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import '../feeds/components/feeds_details.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String route = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _fetchMyPosts()async{
    await ProfileCubit.get(context).getMyPostsId(context);
    await ProfileCubit.get(context).getMyPosts(context);

  }
  @override
  void initState() {
    print("fetch My Posts");
     _fetchMyPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = ProfileCubit.get(context);
    final Size size = MediaQuery.of(context).size;
    final  double height = size.height;
    final double width = size.width;
    UserModel? model;
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) async{},
      builder: (context, state) {
        print("profile Screen");
        model = LayoutCubit.get(context).userModel;
          return RefreshIndicator(
            key: refreshKey,
            onRefresh: () => cubit.getMyPostsOnRefresh(context),
            child: ConditionalBuilder(
              condition: model!=null,
              builder: (context){
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: .35 * height,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Hero(
                                tag: 'cover',
                                child: Container(
                                  height: .26 * height,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage('${model!.cover}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                radius: 0.103 * height,
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: .1 * height,
                                  backgroundImage: NetworkImage(
                                    '${model!.image}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        model!.name ?? " ",
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        model!.bio!,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(fontSize: 14),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(bottom: 15, left: 8, right: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen()));
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
                                height: height + 55,
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
                );
              },
             fallback:(context)=> const Center(child: CircularProgressIndicator( )),
            ),
          );
      },
    );
  }
}
