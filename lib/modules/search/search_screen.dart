import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/layout/cubit/layout_cubit.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_item.dart';
import '../../shared/styles/colors.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> allData = [];
  List searchList = [];
  List <String>searchHistory = [];
  bool searched = false;
  String searchWord = ' ';
  int itemCount = 0;

  @override
  void initState() {
    LayoutCubit.get(context).getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (allData.isEmpty) {
      allData = LayoutCubit.get(context).allUsers;
    }
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) {
                  print(value);
                  searched = true;
                  setState(() {
                    if(value==''){
                      searchList=[];
                      itemCount = searchList.length;
                      searchWord = value;
                      searched=false;
                    }else{
                      searchList = allData.where((user) => user.name!.startsWith(value)).toList();
                      print(searchList);
                      itemCount = searchList.length;
                      searchWord = value;
                    }
                  });
                },
                onFieldSubmitted: (value) {
                  searchHistory.add(value);
                },
                controller: searchController,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 16),
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: const Color(0xffF8F8F8),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/images/Search.svg',
                      ),
                    ),
                    hintText: "Search",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 16)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (searched)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    const Text('Results for “ '),
                    Text(
                      searchWord,
                      style: const TextStyle(color: defaultColor),
                    ),
                    const Text(' "'),
                    const Spacer(),
                    Text(
                      '$itemCount found',
                      style: const TextStyle(color: defaultColor),
                    ),
                  ],
                ),
              ),
            ConditionalBuilder(
                condition: searchList.isNotEmpty,
                builder: (context) => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        ChatItem(searchList[index],searchItem: true),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                    itemCount: searchList.length),
                fallback: (context) => searched
                    ? Center(
                        child: Text(
                              'User Not found',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent History',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Row(
                                        children: [
                                          // SvgPicture.asset('assets/icons/history.svg'),
                                          const Icon(Icons
                                              .history_toggle_off_rounded),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(searchHistory[index]),
                                          const Spacer(),
                                          const Icon(Icons.close_outlined)
                                        ],
                                      ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                  itemCount: searchHistory.length),
                            ],
                          ),
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
