import 'package:flutter/material.dart';
import 'package:graduan_test/model/post_model.dart';
import 'package:graduan_test/services/auth/service.dart';
import 'package:graduan_test/services/list_service/post_service.dart';
import 'package:graduan_test/utils/loading.dart';
import 'package:graduan_test/utils/widget/multiple_button.dart';
import 'package:graduan_test/screen/login_page.dart';
import 'package:graduan_test/utils/widget/custom_input_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textPost = TextEditingController();

  Future<void> useLogout() async {
    bool data = await logout(context);
    if(data){
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pushReplacementNamed(context, '/').catchError((e) {
        debugPrint("Navigation Error: $e");
      });
    }
  }

  Future<List<PostModel>> fetchData() async {
    try {
      return await PostService().getPostList(context);
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  Future<void> postText() async {
    try {
      final params = {
        'title': textPost.text,
      };
      final result = await PostService().createPost(context,params); 
      if(result != null){
        Navigator.pop(context);
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    } catch (e) {
      print("Error create post data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Homepage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<PostModel>>(
          future: fetchData(),
          builder: (context1, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingAnimation());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              return ListView.separated(
                itemCount: data!.length,
                itemBuilder: (context2, index) {
                  final itemData = data[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.amberAccent.withOpacity(0.35)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Title: ${itemData.title}'),
                            Text('ID: ${itemData.id}'),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              itemData.updatedAt,
                              style: const TextStyle(color: Colors.black38),
                            ),
                            Text(
                              itemData.createdAt,
                              style: const TextStyle(color: Colors.black38),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context3, index) => const SizedBox(
                  height: 8,
                ),
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
      floatingActionButton: LinearFlowWidget(
        onCallback: (value) {
          if (value == 'openPost') {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                        20)),
              ),
              builder: (BuildContext context) {
                return Container(
                    height: 400,
                    color: Theme.of(context).primaryColor.withOpacity(0.35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Write anything!'),
                        CustomInputField(
                          controller: textPost,
                          maxLines: 5,
                          hintText: "Write here",
                          onSaved: (value) {
                            textPost.text = value!;
                          },
                        ),
                        GestureDetector(
                          onTap: (){postText();},
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            height: 55,
                            width: 175,
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.greenAccent.withOpacity(0.75),
                            ),
                            child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 5, left: 20, right: 20),
                                    child: const Center(
                                        child: Text('Post it!'),
                                      ),
                                ),
                          ),
                        )
                      ],
                    ),);
              },
            );
          } else if (value == 'logout') {
            useLogout();
          }
        },
      ),
    );
  }
}
