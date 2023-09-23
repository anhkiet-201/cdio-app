import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 200,
            width: 150,
            child: Column(
              children: [
                LoadingIndicator(
                  indicatorType: Indicator.ballZigZagDeflect,
                ),
                SizedBox(height: 20,),
                Text('App is loading')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
