import 'package:flutter/material.dart';
import 'package:hr_huntlng/UI/Login/LoginPage.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroPage extends StatelessWidget {
  List<Slide> slides = new List();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return new IntroSlider(
      slides: [
        Slide(
          styleDescription: TextStyle(fontSize: width * 0.05),
          heightImage: height * 0.55,
          widthImage: width * 0.8,
          title: "Set your Quiz Name",
          description:
              "Click on the Menu button on the left top side and set your Quiz Name",
          pathImage: "./assets/pick_quizname.PNG",
          backgroundColor: klightlogincolor,
        ),
        Slide(
          styleDescription: TextStyle(fontSize: width * 0.05),
          heightImage: height * 0.55,
          widthImage: width * 0.8,
          title: "Registration",
          description:
              "Create your account as admin(@admin.com) or participant account(@xxx.com) ",
          pathImage: "./assets/create_account.PNG",
          backgroundColor: klightlogincolor,
        ),
        Slide(
          styleDescription: TextStyle(fontSize: width * 0.05),
          heightImage: height * 0.55,
          widthImage: width * 0.8,
          title: "Quiz time",
          description: "Complete the Quiz of Feelings as participant",
          pathImage: "./assets/participant_account.PNG",
          backgroundColor: klightlogincolor,
        ),
        Slide(
          styleDescription: TextStyle(fontSize: width * 0.05),
          heightImage: height * 0.55,
          widthImage: width * 0.8,
          title: "Check your results",
          description: "See the results of the Quiz as Admin",
          pathImage: "./assets/admin_account.PNG",
          backgroundColor: klightlogincolor,
        ),
      ],
      onDonePress: () => context.bloc<AuthBloc>().add(IntroToLogin()),
    );
  }
}
