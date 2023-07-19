import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gesture_collection_app/screens/dashboard.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionScreens extends StatelessWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Hello there',
              body:
              'Our application will give a message for particular gestures. \n\n First, let us get a brief idea of the application. The following pages will walk through how we can use the application.',
              image: SvgPicture.asset("assets/welcome.svg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Home Screen',
              body:
              'After this demo, the home screen will be the first screen whenever we open the application. It has two tabs. \n\n 1. Try Gesture Tab \n 2. Library Tab',
              image: SvgPicture.asset("assets/tabs_intro.svg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Try Gesture Tab',
              body:
              'Click on the record button and make a gesture in 2 seconds. After that, You will hear a voice message for that gesture.',
              image: SvgPicture.asset("assets/record_intro.svg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Library Tab',
              body:
              'So, not every gesture that you make will give sound. The gestures you perform must be in the library. There are two types of gestures in Library \n 1. Default Gestures \n 2.Your Gestures',
              image: SvgPicture.asset("assets/library.svg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Default Gesture',
              body:
              'Our application consists of some gestures by default. It will be the same for all users. You can also view how to perform individual gestures by clicking on the gesture tile',
              image: SvgPicture.asset("assets/library.svg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Your own gestures',
              body:
              'In the my Gesture Tab, The Gestures are created and used specifically by you. To access or create you need to log in. After that, You can add your gesture by clicking on the + Icon and by following the instructions on the screen.',
              image: SvgPicture.asset("assets/add_gesture.svg"),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
          ],
          onDone: () {
            if (kDebugMode) {
              print("Done clicked");
            }
          },
          //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
          scrollPhysics: const ClampingScrollPhysics(),
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: true,
          //isBottomSafeArea: true,
          skip: const Text("Skip",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFFFF4573))),
          next: const Icon(
            Icons.forward,
            color: Color(0xFFFF4573),
          ),
          done: InkWell(
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Dashboard())),
              child: const Text("Done",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFFFF4573)))),
          dotsDecorator: getDotsDecorator()),
    );
  }

  //widget to add the image on screen
  Widget buildImage(String imagePath) {
    return Center(
        child: Image.asset(
          imagePath,
          width: 1000,
          height: 1000,
        ));
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Color(0xFFFF4573),
      color: Colors.grey,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
