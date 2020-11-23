import 'package:flutter/material.dart';
import 'package:hr_huntlng/bloc/auth/auth_bloc.dart';
import 'package:hr_huntlng/utils/colors_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroPage extends StatelessWidget {
  

  

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('./assets/pick_quizname.PNG'), context);
    precacheImage(AssetImage('./assets/create_account.PNG'), context);
    precacheImage(AssetImage('./assets/quiz_time.png'), context);
    precacheImage(AssetImage('./assets/quiz_results.png'), context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: new IntroSlider(
        slides: [
          Slide(
            styleDescription: TextStyle(fontSize: width * 0.05),
            heightImage: height * 0.45,
            widthImage: width * 0.8,
            title: "Set your Quiz Name",
            description:
                "Click the Menu button on the left top side and set your Quiz Name",
            pathImage: "./assets/pick_quizname.PNG",
            backgroundColor: klightlogincolor,
          ),
          Slide(
            styleDescription: TextStyle(fontSize: width * 0.05),
            heightImage: height * 0.45,
            widthImage: width * 0.8,
            title: "Be participant or Admin",
            description:
                "Create your account as admin(@admin.com) or participant (@xxx.com) ",
            pathImage: "./assets/create_account.PNG",
            backgroundColor: klightlogincolor,
          ),
          Slide(
            styleDescription: TextStyle(fontSize: width * 0.05),
            heightImage: height * 0.45,
            widthImage: width * 0.8,
            title: "Quiz Time",
            description: "Complete the Quiz of Feelings as participant",
            pathImage: "./assets/quiz_time.png",
            backgroundColor: klightlogincolor,
          ),
          Slide(
            styleDescription: TextStyle(fontSize: width * 0.05),
            heightImage: height * 0.45,
            widthImage: width * 0.8,
            title: "Check your results",
            description: "See the results of the Quiz as Admin",
            pathImage: "./assets/quiz_results.png",
            backgroundColor: klightlogincolor,
          ),
        ],
        onDonePress: () => context.bloc<AuthBloc>().add(IntroToLogin()),
      ),
    );
  }
}
