import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import '../feeds/components/feeds_details.dart';
import 'cubit/user_profile_cubit.dart';
import 'cubit/user_profile_states.dart';

class UsersProfileScreen extends StatefulWidget {
  final UserModel user;

  const UsersProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UsersProfileScreen> createState() => _UsersProfileScreenState();
}

class _UsersProfileScreenState extends State<UsersProfileScreen> {
  final GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();

  _fetchUserPosts() async {
    await UserProfileCubit.get(context).getUserPosts(widget.user.uId!);
  }

  @override
  void initState()  {
    _fetchUserPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    var cubit = UserProfileCubit.get(context);
    return BlocBuilder<UserProfileCubit,UserProfileStates>(
      builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: RefreshIndicator(
                key: refreshKey,
                onRefresh: () => cubit.getUserPosts(widget.user.uId!),
                child:  SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: .35 * height,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional.topCenter,
                                  child: Container(
                                    height: .26 * height,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                      ),
                                      image: DecorationImage(
                                        image:
                                        NetworkImage('${widget.user.cover}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: 'userImage',
                                  child: CircleAvatar(
                                    radius: 0.103 * height,
                                    backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                    child: CircleAvatar(
                                      radius: .1 * height,
                                      backgroundImage: NetworkImage(
                                        '${widget.user.image}',
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
                            widget.user.name ?? " ",
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.user.bio!,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 20,),
                          ConditionalBuilder(
                            condition: cubit.userPosts.isNotEmpty,
                            builder: (context) {
                              return ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => PostItem(
                                    height: height + 55,
                                    width: width,
                                    model: cubit.userPosts[index],
                                    index: index,
                                  ),
                                  separatorBuilder: (context, index) => SizedBox(
                                    height: .025 * height,
                                  ),
                                  itemCount: cubit.userPosts.length);
                            },
                            fallback: (context){
                              if(state is GetUserPostsLoadingState){
                                return const Center(child: CircularProgressIndicator(),);
                              }else{
                                return const Center(child: Text("No Posts Yet",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 24),),);
                              }
                            }
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          );
      },
    );
  }
}
