import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/layout/cubit/layout_states.dart';
import 'package:social_app/modules/feeds/feeds_details.dart';

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
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty && cubit.postsId.isNotEmpty,
          builder: (context) {
            print("$state ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
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

// Card(
// elevation: 5.0,
// clipBehavior: Clip.antiAliasWithSaveLayer,
// margin: const EdgeInsetsDirectional.all(7),
// child: Stack(
// alignment: AlignmentDirectional.bottomEnd,
// children: [
// const Image(
// image: NetworkImage(
// 'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg'),
// ),
// Padding(
// padding: const EdgeInsets.all(5),
// child: Text(
// "communicate with friends",
// style: Theme.of(context)
// .textTheme
//     .subtitle1
//     ?.copyWith(color: Colors.white),
// ),
// ),
// ],
// ),
// ),
// SizedBox(
// height: 0.016 * screenHeight,
// ),
