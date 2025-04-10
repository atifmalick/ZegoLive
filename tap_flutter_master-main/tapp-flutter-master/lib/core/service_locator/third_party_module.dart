import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

@module
abstract class ThirdPartyModule {
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @injectable
  ImagePicker get imagePicker => ImagePicker();

  @injectable
  GraphQLClient get graphqlClient {
    final HttpLink httpLink =
        HttpLink('https://tapp.social-standard.com/graphql'
            //  'https://tapp-d9rog.ondigitalocean.app/graphql'
            // "http://137.184.82.135/graphql"
            );

    final AuthLink authLink = AuthLink(
      getToken: () async {
        final token =
            'Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken(true)}';
        return token;
      },
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(link: link, cache: GraphQLCache());
  }
}
