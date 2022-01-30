import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String getUser = """
query GetUser (
  \$id: ID!
) {
  photo(id: \$id) {
    album {
      id
      title
      user {
        id
      }
    }
  }
}
""";

    return Scaffold(
      appBar: AppBar(
        title: Text("GraphQL Flutter"),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getUser),
          variables: {
            'id':1
          }
        ),
        builder: (result, {refetch, fetchMore}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //final Posts posts = Posts.fromJson(result.data);
          print(result.data);
          return Text(result.data.toString());
        },
      ),
    );
  }
}
