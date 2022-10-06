import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'components/feeds_details.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);
  GlobalKey refreshKey = GlobalKey<RefreshIndicatorState>();
  static String route = 'feeds_screen';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return BlocConsumer<LayoutCubit, LayoutStates>(
      buildWhen: (previous, current) => (current is GetPostsSuccessState||current is GetPostsLoadingState ||current is NewPostCreatedState),
      listener: (context, state) {},
      builder: (context, state) {
        print("$state ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        var cubit = LayoutCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty && cubit.postsId.isNotEmpty,
          builder: (context) {
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: () {
                return LayoutCubit.get(context).getAllPostsOnRefresh();
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                        children: [
                          PostItem(
                            height: screenHeight,
                            width: screenWidth,
                            model: cubit.posts[index],
                            index: index,
                          ),
                          SizedBox(
                            height: .025 * screenHeight,
                          )
                        ],
                      ),
                      childCount: cubit.posts.length,
                    ),
                  ),
                ],
              ),
            );
          },
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
