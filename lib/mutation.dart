import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MutationPage extends StatefulWidget {
  @override
  _MutationPageState createState() => _MutationPageState();
}

class _MutationPageState extends State<MutationPage> {
  final nameController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String createPost = """
mutation insert_post(\$title: String!, \$body: String!){
  createPost(input: {title: \$title, body: \$body}){
    title,
    body
  }
}
""";

    return Scaffold(
      appBar: AppBar(
        title: Text("Mutation"),
        centerTitle: true,
      ),
      body: Mutation(
        options: MutationOptions(
            document: gql(createPost),
            update: (GraphQLDataProxy cache, QueryResult result) {
              return cache;
            },
            onCompleted: (result) {
              print(result);
              print("onCompleted called");
            }),
        builder: (RunMutation insert, QueryResult result) {
          return Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Name"),
                controller: nameController,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Body'),
                controller: bodyController,
              ),
              TextButton(
                onPressed: () async {
                  print(nameController.text);
                  print(bodyController.text);
                  insert(<String, dynamic>{
                    "title": nameController.text,
                    "body": bodyController.text
                  });
                },
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Colors.black,
                    textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600)),
                child: Text('Book Now'),
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: Text(
                    result.data == null
                        ? '''Post details coming up shortly,'''
                        ''' Kindly enter details and create a post'''
                        : result.data.toString(),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
