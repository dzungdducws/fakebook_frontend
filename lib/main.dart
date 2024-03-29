import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fakebook_frontend/blocs/comment/comment_bloc.dart';
import 'package:fakebook_frontend/blocs/friend/friend_bloc.dart';
import 'package:fakebook_frontend/blocs/personal_post/personal_post_bloc.dart';
import 'package:fakebook_frontend/blocs/list_video/list_video_bloc.dart';
import 'package:fakebook_frontend/blocs/post_detail/post_detail_bloc.dart';
import 'package:fakebook_frontend/blocs/signup/signup_bloc.dart';
import 'package:fakebook_frontend/repositories/post_repository.dart';
import 'package:fakebook_frontend/repositories/request_received_friend_repository.dart';
import 'package:fakebook_frontend/repositories/signup_repository.dart';

import 'package:fakebook_frontend/repositories/video_repository.dart';
import 'package:fakebook_frontend/routes.dart';
import 'package:fakebook_frontend/blocs/auth/auth_bloc.dart';
import 'package:fakebook_frontend/blocs/auth/auth_event.dart';
import 'package:fakebook_frontend/blocs/auth/auth_state.dart';
import 'package:fakebook_frontend/screens/personal/personal_screen.dart';
import 'package:fakebook_frontend/screens/request_received_friend/sub_screens/list_friend_screen.dart';
import 'package:fakebook_frontend/screens/request_received_friend/sub_screens/unknown_people_screen.dart';
import 'package:fakebook_frontend/screens/post/emotion_screen.dart';
import 'package:fakebook_frontend/screens/messenger/messenger_screen.dart';
import 'package:fakebook_frontend/simple_bloc_observer.dart';
import 'package:flutter/material.dart';

import 'package:fakebook_frontend/constants/assets/palette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import './screens/screens.dart';
import 'blocs/personal_info/personal_info_bloc.dart';
import 'blocs/post/post_bloc.dart';
import 'blocs/request_received_friend/request_received_friend_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/unknow_people/unknow_people_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  final client = StreamChatClient(
    '6za27trdby7z',
    logLevel: Level.OFF,
  );

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // debug global BLOC, suggesting turn off, please override in debug local BLOC
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;
  const MyApp({super.key, required this.client});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PostRepository postRepository = PostRepository();
    VideoRepository videoRepository = VideoRepository();
    SignupRepository signupRepository = SignupRepository();
    FriendRequestReceivedRepository friendRequestReceivedRepository = FriendRequestReceivedRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          lazy: false,
          create: (_) => AuthBloc()..add(KeepSession())
        ),
        BlocProvider<PostBloc>(
          lazy: false,
          create: (_) => PostBloc(postRepository: postRepository),
        ),
        BlocProvider<PostDetailBloc>(
          lazy: false,
          create: (_) => PostDetailBloc(postRepository: postRepository)
        ),
        BlocProvider<PersonalPostBloc>(
          lazy: false,
          create: (_) => PersonalPostBloc(postRepository: postRepository)
        ),
        BlocProvider<CommentBloc>(
          lazy: false,
          create: (_) => CommentBloc(),
        ),
        BlocProvider<ListVideoBloc>(
            lazy: false,
            create: (_) => ListVideoBloc(videoRepository: videoRepository)
        ),
        BlocProvider<RequestReceivedFriendBloc>(
            lazy: false,
            create: (_) => RequestReceivedFriendBloc()
        ),
        BlocProvider<PersonalInfoBloc>(
          lazy: false,
          create: (_) => PersonalInfoBloc(),
        ),
        BlocProvider<FriendBloc>(
          lazy: false,
          create: (_) => FriendBloc(),
        ),
        BlocProvider<SignupBloc>(
          lazy: false,
          create: (_) => SignupBloc(signupRepository: signupRepository),
        ),
        BlocProvider<ListUnknownPeopleBloc>(
          lazy: false,
          create: (_) => ListUnknownPeopleBloc(),
        ),
        BlocProvider<SearchBloc>(
          lazy: false,
          create: (_) => SearchBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Fakebook',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Palette.scaffold
        ),
        builder: (context, child) {
          return StreamChat(client: client, child: child);
        },
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              switch (state.status) {
                case AuthStatus.unknown:
                  return LoginScreen();
                case AuthStatus.unauthenticated:
                  return LoginScreen();
                case AuthStatus.loginFail:
                  return LoginScreen(x: true);
                case AuthStatus.authenticated:
                  return NavScreen();
              }
            }
        ),
        onGenerateRoute: (settings) {
            switch (settings.name) {
              // case Routes.home_screen:
              //   return MyApp(); // lỗi
              //   break;
              // Bởi vì cập nhật state bằng Bloc nên không cần push từ Login
              case Routes.login_screen:
                return MaterialPageRoute(builder: (_) => LoginScreen());
                break;
              case Routes.nav_screen:
                return MaterialPageRoute(builder: (_) => NavScreen());
                break;
              case Routes.post_detail_screen: {
                // return MaterialPageRoute(builder: (_) => PostDetailScreen()); // null arguments ???
                final postId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: postId));
              }
              case Routes.create_post_screen:
                return MaterialPageRoute(builder: (_) => CreatePostScreen());
              case Routes.emotion_screen:
                return MaterialPageRoute(builder: (_) => EmotionScreen());
              case Routes.personal_screen: {
                final String? accountId = settings.arguments as String?;
                return MaterialPageRoute(builder: (_) => PersonalScreen(accountId: accountId));
              }
              // case Routes.messenger_screen: {
              //   return MaterialPageRoute(builder: (_) => MessengerScreen());
              // }
              case Routes.friend_screen: {
                return MaterialPageRoute(builder: (_) => FriendScreen());
              }
              case Routes.unknow_people_screen: {
                return MaterialPageRoute(builder: (_) => UnknowPeopleScreen());
              }
              default:
                return MaterialPageRoute(builder: (_) => NavScreen());
            }
        }
      ),
    );
  }
}

