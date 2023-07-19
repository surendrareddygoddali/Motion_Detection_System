import 'package:flutter/material.dart';
import 'package:gesture_collection_app/models/gesture.dart';
import 'package:gesture_collection_app/services/GestureAudioLinkService.dart';
import 'package:gesture_collection_app/widgets/top_nav_bar.dart';

class PlayAudioScreen extends StatefulWidget {
  static const String routeName = "/playaudio";

  @override
  _PlayAudioScreenState createState() => _PlayAudioScreenState();
}

class _PlayAudioScreenState extends State<PlayAudioScreen> {
  String audioName = "";
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => playAudio(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        height: 300,
        title: "Playing Audio...",
        backlink: "/speech",
        navEnabled: true,
      ),
      body: Container(
          child: Center(
              child: Column(children: [
                Text("Playing audio " +
                    this.audioName), //TODO: make async, probably need FutureBuilder class
                Text("PLay Audio Screen"),
              ]))),
    );
  }

  playAudio(BuildContext context) {
    final Map args =
    ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    Future<Gesture> detectedGesture = args["gesture"];
    String audioURI =
    GestureAudioLinkService.getAudioForGesture(detectedGesture);
    this.audioName = audioURI;
  }
}
