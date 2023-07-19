import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:gesture_collection_app/models/GestureData.dart';
import 'package:gesture_collection_app/models/gesture.dart';
import 'package:gesture_collection_app/services/GestureAudioLinkService.dart';
import 'package:gesture_collection_app/services/gesture_service.dart';
import 'package:gesture_collection_app/services/shared_preferences_service.dart';
import 'package:gesture_collection_app/utility/Util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math' as math;
import 'package:sensors/sensors.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class RecordGestureScreen extends StatelessWidget {
  static const String routeName = "/recordgesture";
  static const platform = const MethodChannel('ondeviceML');
  var backRouteName = "/speechcollect";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CountDownTimer(),
      // debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   iconTheme: IconThemeData(
      //     color: Colors.white,
      //   ),
      //   accentColor: Colors.indigo,
      // ),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();

  // or as a local variable
  final player = AudioCache();
  bool isCollectingGesture = false;
  late String selecteLabel;
  // String selecteLabel = LabelWidget().labelName;
  late AnimationController controller;

  @override
  bool get wantKeepAlive => true;
  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int count = 0;
  String? userId = '';
  var xyz = [];
  var abc = [];
  var gestures = [];
  var a = [];
  double time = 3;
  List<double> xUnScaled = new List<double>.filled(3, 0, growable: true);
  List<double> yUnScaled = new List<double>.filled(3, 0, growable: true);
  List<double> zUnScaled = new List<double>.filled(3, 0, growable: true);
  late AccelerometerEvent event;
  late Timer timer;
  late StreamSubscription accel;
  var uploadGesture = "";
  late SharedPreferences prefs;
  late GestureService gestureService;

  /*Future<void> createUser() async {
    prefs = await SharedPreferences.getInstance();
    String _userId = prefs.getString("userId");
    if (_userId == null || userId == '') {
      var uuid = Uuid();
      prefs.setString("userId", uuid.v1());
    }
    userId = _userId;
  }*/
  Future<void> getUserId() async {
    prefs = await SharedPreferences.getInstance();
    String? _userId = prefs.getString("userId");
    userId = _userId;
  }

  var l;
  // List<MeasuredDataObject> l = [];
  @override
  void initState() {
    gestureService = new GestureService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map args = (ModalRoute.of(context)!.settings.arguments??{}) as Map;
    if (args == {}) {
      this.isCollectingGesture = args["collecting"];
      this.uploadGesture = args["data"];
    }
    getUserId();
    if (this.isCollectingGesture) {
      selecteLabel = "Register a new gesture for\n";
      print(this.uploadGesture);
      time = 4;
    } else {
      selecteLabel = "Perform a gesture";
    }
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: time.toInt()),
    )
      ..addStatusListener((state) => print(""))
      ..stop();

    ThemeData themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white10,
                      height:
                      controller.value * MediaQuery.of(context).size.height,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.topCenter,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: CustomTimerPainter(
                                          animation: controller,
                                          backgroundColor: Colors.white,
                                          color: themeData.indicatorColor,
                                        )),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        this.isCollectingGesture != null &&
                                            !this.isCollectingGesture
                                            ? Text(
                                          selecteLabel.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                            : RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent

                                            children: <TextSpan>[
                                              TextSpan(
                                                text: this
                                                    .selecteLabel
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily:
                                                    'Montserrat',
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                  text: this
                                                      .uploadGesture
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                      'Montserrat',
                                                      fontWeight:
                                                      FontWeight
                                                          .bold)),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          timerString,
                                          style: TextStyle(
                                            fontSize: 100.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        AnimatedBuilder(
                            animation: Tween<double>(begin: 0, end: time)
                                .animate(controller),
                            builder: (context, child) {
                              return SizedBox(
                                  width: 125.0,
                                  height: 125.0,
                                  child: FloatingActionButton.extended(
                                      onPressed: () {
                                        if (controller.isAnimating) {
                                          controller.stop();
                                        } else {
                                          accel = accelerometerEvents.listen(
                                                  (AccelerometerEvent event) {
                                                //print(event);
                                                xyz.add(DateTime.now()
                                                    .millisecondsSinceEpoch);

                                                //print(selecteLabel);
                                                int dateAdded = DateTime.now()
                                                    .millisecondsSinceEpoch;
                                                xUnScaled.add(event.x);
                                                yUnScaled.add(event.y);
                                                zUnScaled.add(event.z);
                                                Gesture gesture = new Gesture(
                                                    userId as String,
                                                    selecteLabel,
                                                    event.x.toString(),
                                                    event.y.toString(),
                                                    event.z.toString(),
                                                    dateAdded);
                                                //xyz.add(event.x.toString());
                                                //xyz.add(event.y.toString());
                                                //xyz.add(event.z.toString());
                                                //abc.add(xyz);

                                                gestures.add(gesture);
                                                if (isCollectingGesture) {
                                                  // Uncomment if you want to upload data without confirmation from user
                                                  //gestureService.addGesture(gesture);
                                                }

                                                //GestureService.addGesture(gesture);
                                                /*Provider.of<GestureService>(context,
                                                listen: false)
                                            .addProduct(gesture);*/
                                                count++;
                                                //xyz = []
                                                if (!controller.isAnimating) {
                                                  count = 0;
                                                  //print(abc);
                                                  //print("count " + gestures.length.toString());
                                                  var gesturesStrings = [];

                                                  for (Gesture gesture
                                                  in gestures) {
                                                    //print("x: " + gesture.xData +  " y: " + gesture.yData + " z: " + gesture.zData);
                                                    var combine = gesture.xData +
                                                        ":" +
                                                        gesture.yData +
                                                        ":" +
                                                        gesture.zData;
                                                    gesturesStrings.add(combine);
                                                  }

                                                  if (!isCollectingGesture) {
                                                    this._getPredictData(
                                                        gesturesStrings);
                                                  }

                                                  accel.cancel();
                                                  if (!this.isCollectingGesture) {
                                                    //Araib Edits
                                                    gestures = [];
                                                    //Future<Gesture> detectedGesture= gestureService.detectGesture(gestures);
                                                    //Navigator.of(context).pushNamed(this.nextLink, arguments: {'gesture': detectedGesture});
                                                  } else {
                                                    //Navigator.of(context).pushNamed(this.nextLink, arguments: {'showDialog': 'yes'});
                                                    showGestureCollectionDialog();
                                                  }
                                                }
                                              });

                                          controller.reverse(
                                              from: controller.value == 0.0
                                                  ? 1.0
                                                  : controller.value);
                                        }
                                      },
                                      label: Text(
                                          controller.isAnimating
                                              ? "STOP"
                                              : "RECORD",
                                          style: new TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ))));
                            }),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );

  }

  // @override
  // void dispose() {
  //   timer.cancel();
  //   accel.cancel();
  // }

  void showGestureCollectionDialog() {
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromBottom,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(color: Colors.black, fontSize: 16),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(color: Colors.black, fontSize: 18),
        constraints: BoxConstraints.expand(width: 300),
        //First to chars "55" represents transparency of color
        overlayColor: Color(0x70000000),
        alertElevation: 0,
        alertAlignment: Alignment.center);

    Alert(
      context: context,
      title: " New Gesture Created: " + this.uploadGesture,
      desc: "Do you want to upload the data?",
      style: alertStyle,
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () => closeGestureCollectionDialog(),
          color: Colors.blueGrey,
        ),
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () => uploadGestureCollectionData(),
          color: Colors.redAccent,
        )
      ],
    ).show();
  }

  void closeGestureCollectionDialog() {
    Navigator.pop(context);
    gestures = [];
  }

  void uploadGestureCollectionData() {
    Navigator.pop(context);
    /*for(Gesture gesture in gestures){
       gestureService.addGesture(gesture).then((value){
         if(value){
           Fluttertoast.cancel();
           Fluttertoast.showToast(
               msg: "The data has been uploaded",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.white,
               textColor: Colors.black,
               fontSize: 16.0
           );
         }

      });

    }*/
    var gestureCompleteData = [];
    for (Gesture gesture in gestures) {
      var singleGesture = [];
      singleGesture.add(gesture.xData);
      singleGesture.add(gesture.yData);
      singleGesture.add(gesture.zData);
      gestureCompleteData.add(singleGesture);
    }
    GestureData data =
    GestureData(userId as String, uploadGesture, gestureCompleteData);
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    GestureService.uploadGestureData(userId as String, timeStamp, data)
        .then((value) {
      if (value) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: "The data has been uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
    gestures = [];
    Navigator.pop(context);
  }

  double getScaledValue(
      double currentValue, double median, double q1, double q3) {
    //double q1 = Util.quartile(array, 25);
    //double q2 = Util.quartile(array, 50);
    //double q3 = Util.quartile(array, 75);

    //double median =  Util.calculateMedian(array);
    double value = (currentValue - median) / (q3 - q1);
    return value;
  }

  double getQuartile(List<double> array, double num) {
    double q1 = Util.quartile(array, num);
    return q1;
  }

  double getMedian(var array) {
    double q1 = Util.calculateMedian(array);
    return q1;
  }

  Future<void> _getPredictData(var data) async {
    try {
      final String result = await RecordGestureScreen.platform.invokeMethod(
          'predictData', {"data": data.toString()}); // passing arguments
      //here inp has our matrix returned by tokenizer class
      print("Result: " + result);
      SharedPreferencesService.getCustomGestureText(result).then((value) => {
        if (value != null)
          {GestureAudioLinkService.speak_from_text(value)}
        else
          {
            SharedPreferencesService.getGestureList().then((gestureList) =>
            {playAudioTextFromGestureList(result, gestureList)})
          }
      });
      /*if(result == "waving"){
         playLocal("hello");
      }else if(result == "circle"){
         //playLocal("seeyoutomorrow");
      }else if(result == "dab"){
        // playLocal("seeyoutomorrow");
      }else if(result == "drinking"){
        playLocal("seeyoutomorrow");
      }else if(result == "lineH"){
        playLocal("yourwelcome");
      }else if(result == "lineV"){
        playLocal("goodbye");
      }else if(result == "outwardsL"){

      }else if(result == "outwardsR"){

      }else if(result == "semicircle"){
        playLocal("hello");
      }else if(result == "towards"){
        playLocal("thankyou");

      }else if(result == "xmark"){
        playLocal("thankyou");
      }*/

    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  playAudioTextFromGestureList(String result, List value) {
    print(result);
    for (var data in value) {
      print(data["name"]);
      if (data["name"] == result) {
        GestureAudioLinkService.speak_from_text(data["audio"]);
        break;
      }
    }
  }

  playLocal(var local) async {
    var file = local + ".mp3";
    print(file);
    player.load(file);
  }

  void LogPrint(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);

    // Accelerometer events come faster than we need them so a timer is used to only proccess them every 200 milliseconds
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
