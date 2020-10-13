import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/UI/Admin/AdminPage.dart';
import 'package:hr_huntlng/UI/Login/LoginPage.dart';
import 'package:hr_huntlng/UI/Rating/RatingPage.dart';
import 'package:hr_huntlng/UI/Splash/SplashPage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';
import 'package:hr_huntlng/repository/rating/rating_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
    appId: '1:1048262391656:android:8ffbe948fb7a9f95f588dd',
    messagingSenderId: '...',
    projectId: '...',
    apiKey: 'AIzaSyAPhM0lrpenTg0a9Jg0B6L1uhfAm-uqTz0',
    databaseURL: 'https://huntlng.firebaseio.com',
  ));

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (context) => AuthService()),
      RepositoryProvider(create: (context) => RatingService()),
    ],
    child: BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc()..add(AppLoaded());
      },
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz of Feelings',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return RatingPage(
              user: state.user,
            );
          } else if (state is AuthenticationAdmin) {
            return AdminPage(
              user: state.user,
              data: state.data,
            );
          } else if (state is AuthenticationLoading) {
            return SplashPage();
          } else {
            return LoginPage();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
