import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gesture_collection_app/models/gesture.dart';

late AudioPlayer audioPlayer;
FlutterTts flutterTts = FlutterTts();

class GestureAudioLinkService {
  //TODO: Create links between gestures and audio outputs
  static String getAudioForGesture(Future<Gesture> detectedGesture) {
    return "exampleaudio.mp3";
  }

  // This is just play audio from mp3 file using mp3 audio file URL
  static playAudio(path) async {
    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(1);
    // path="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";

    await audioPlayer.play(path);
    // if (response == 1) {
    //   // success
    //   print("success");
    // } else {
    //   print('Some error occured in playing from storage!');
    // }
    print(audioPlayer.getCurrentPosition());
  }

  static stopAudio() async {
    audioPlayer.stop();
    // if (response == 1) {
    //   // success
    // } else {
    //   print('Some error occured in stopping');
    // }
  }

  //THis is dynamic text to speech just need text and it is using flutterTts library to text to speech for conversation
  static speak_from_text(text) async {
    List<dynamic> languages = await flutterTts.getLanguages;
    print(languages);
    await flutterTts.setLanguage("en-US");
    // await flutterTts.setLanguage("gu-IN");
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    // await flutterTts.setPitch(0.1);
    var result = await flutterTts.speak(text);
    print(result);
  }
}
