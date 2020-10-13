import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: LottieBuilder.network(
          'https://assets2.lottiefiles.com/packages/lf20_m29kLt.json'),
    );
  }
}
