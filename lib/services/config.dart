import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlObject {
  static HttpLink httpLink = HttpLink(
    uri: 'http://103.133.149.7:8080/v1/graphql',
  );

  static AuthLink authLink = AuthLink();
  static Link link = httpLink;// as Link;

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: InMemoryCache (),
    ),
  );
}

GraphQlObject graphQlObject = new GraphQlObject();