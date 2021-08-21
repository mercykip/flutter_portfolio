import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolio/application/services/api_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBlog extends StatefulWidget {
  @override
  _MyBlogState createState() => _MyBlogState();
}

class _MyBlogState extends State<MyBlog> {
  ApiProvider apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();

    getMediumData();
  }

  late bool isLoading = false;
  late String searchTerm;
  late String title;
  //List<MediumWidget> todoWidgets = [];
  TextEditingController editingController = TextEditingController();
  late String descrip;
  late int length;
  List<dynamic> itemsList = [];
  var mediumData;
  late String imageUrl;

  Future getMediumData() async {
    mediumData = await apiProvider.getBlogs();
    title = mediumData['feed']['title'];
    imageUrl = mediumData['items'][0]['thumbnail'];
    isLoading = true;
    print(imageUrl);
    setState(() {
      itemsList = mediumData['items'];
    });
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      //scrollDirection: Axis.horizontal,
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: itemsList.length,
                      itemBuilder: (BuildContext context, int i) {
                        if (editingController.text.isEmpty) {
                          return InkWell(
                            onTap: () {
                              _launchURL(mediumData['items'][i]['link']);
                            },
                            child: ListViewItems(
                              author: mediumData['items'][i]['author'],
                              imageUrl: mediumData['items'][i]['thumbnail'],
                              title: mediumData['items'][i]['title'],
                            ),
                          );
                        } else if (mediumData['items'][i]['title']
                            .toLowerCase()
                            .contains(editingController.text)) {
                          return InkWell(
                            onTap: () {
                              launch(mediumData['items'][i]['link']);
                            },
                            child: ListViewItems(
                              author: mediumData['items'][i]['author'],
                              imageUrl: mediumData['items'][i]['thumbnail'],
                              title: mediumData['items'][i]['title'],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListViewItems extends StatelessWidget {
  const ListViewItems(
      {required this.imageUrl, required this.author, required this.title});

  final String imageUrl;
  final String author;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(0.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              imageUrl,
              height: 200,
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 500,
              height: 70,
              child: Container(
                padding: EdgeInsets.all(2.0),
                color: Colors.grey[600],
                child: Column(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Text(
                      author,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
