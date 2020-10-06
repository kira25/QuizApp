import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_huntlng/UI/Home/HomePage.dart';
import 'package:hr_huntlng/UI/Login/LoginPage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/repository/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: '1:1048262391656:android:8ffbe948fb7a9f95f588dd',
          messagingSenderId: '...',
         
          projectId: '...',
          apiKey: 'AIzaSyAPhM0lrpenTg0a9Jg0B6L1uhfAm-uqTz0',
          databaseURL: 'https://huntlng.firebaseio.com'));
  runApp(RepositoryProvider(
    create: (context) {
      return AuthService();
    },
    child: BlocProvider<AuthBloc>(
      create: (context) {
        final authService = RepositoryProvider.of<AuthService>(context);
        return AuthBloc(authService)..add(AppLoaded());
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
            return MainScreen(user: state.user,);
          } else {
            return LoginPage();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
