import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Pagination extends StatefulWidget {
  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  final PagingController<int, dynamic> pagingController =
      PagingController(firstPageKey: 1);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) async {
      /*await fetchHotelList(pageKey, selectedFilter, selectedRating,
          price.value, selectedFacilities);*/
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String getUser = """
query GetPost(
\$page: Int!
) {
  posts(options: {
    paginate:{
      page:\$page,
      limit:5
    },
  }) {
    data {
      id
      title
    }
    links{
      first{
        page
        limit
      }
      next{
        page
        limit
      }
      last{
        page
        limit
      }
    }
    meta {
      totalCount
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
        options: QueryOptions(document: gql(getUser), variables: {
          'page': 1,
        }),
        builder: (result, {refetch, fetchMore}) {
          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.hasException) {
            return Text('\nErrors: \n  ' + result.exception.toString());
          }

          if (result.data == null && result.exception.toString() == null) {
            return const Text('Both data and errors are null');
          }
          //final Posts posts = Posts.fromJson(result.data);
          //print(result.data);

          //print(result.data['posts']['data']);

          print(result.data);
          final List<dynamic> blockchainTX =
              (result.data['posts']['data'] as List<dynamic>);

          final Map pageInfo = result.data['posts']['links'];

          final fetchMoreCursor = pageInfo['next']['page'];

          FetchMoreOptions opts = FetchMoreOptions(
            variables: {'page': fetchMoreCursor},
            updateQuery: (previousResultData, fetchMoreResultData) {
              final List<dynamic> repos = [
                ...previousResultData['posts']['data'] as List<dynamic>,
                ...fetchMoreResultData['posts']['data'] as List<dynamic>
              ];

              fetchMoreResultData['posts']['data'] = repos;
              print(fetchMoreResultData);
              return fetchMoreResultData;
            },
          );

          /* _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              if (!result.isLoading) {
                fetchMore(opts);
                print("adsfasd");
              }
            }
          });*/

          return NotificationListener<ScrollUpdateNotification>(
            onNotification: (t) {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                fetchMore(opts);
              }
              fetchMore(opts);
              return true;
            },
            child: ListView.builder(
                controller: _scrollController,
                itemCount: result.data.length,
                itemBuilder: (_, index) {
                  return Text(
                    index.toString(),
                    style: TextStyle(fontSize: 18),
                  );
                }),
          );

          //return Text(result.data.toString());

          return PagedListView<int, dynamic>(
            shrinkWrap: true,
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
                itemBuilder: (context, item, index) {
              return Text(item.toString());
            }),
          );
        },
      ),
    );
  }
}
