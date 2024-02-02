import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RestApi extends StatefulWidget {
  const RestApi({Key? key}) : super(key: key);

  @override
  State<RestApi> createState() => _RestApiState();
}

class _RestApiState extends State<RestApi> {
  List<dynamic> usersData = [];
  TextEditingController searchController = TextEditingController();

  void _getGitUser(String query) {
    String url =
        "https://api.github.com/search/users?q=$query&per_page=10&page=2";
    http.get(Uri.parse(url)).then(
      (response) {
        setState(() {
          usersData = json.decode(response.body)['items'];
        });
      },
    ).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Container(
          height: 70,
          width: double.infinity,
          color: Colors.cyan,
          child: Center(
            child: Text(
              "Liste des utilisateurs",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: "Rechercher",
                      prefixIcon: Icon(
                        Icons.group_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      constraints: BoxConstraints(minHeight: 10),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _getGitUser(searchController.text);
                  },
                  child: const Text("Recharger"),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                if (usersData.isEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 60),alignment: Alignment.center,
                    child: Image.asset('assets/NoUsers.png'),
                  ),
                for (var user in usersData)
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 20),
                    margin: EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            user['avatar_url'],
                          ),
                          radius: 30,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(user['login']),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
