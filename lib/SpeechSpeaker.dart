import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechSpeaker extends StatefulWidget {
  SpeechSpeaker({Key key, @required this.speech, @required this.language})
      : super(key: key);

  final String language;
  final String speech;

  @override
  SpeechSpeakerState createState() {
    return new SpeechSpeakerState();
  }
}

class SpeechSpeakerState extends State<SpeechSpeaker> {
  bool speaking = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
        iconSize: 35.0,
        icon: Icon(Icons.volume_up),
        onPressed: speak,
        color: speaking ? Colors.blueAccent : Colors.black);
  }

  void speak() async {
    FlutterTts tts = new FlutterTts();
    // print(await tts.getLanguages);
    await tts.setLanguage(widget.language);
    tts.setStartHandler(() {
      setState(() {
        speaking = true;
      });
    });

    tts.setCompletionHandler(() {
      setState(() {
        speaking = false;
      });
    });

    tts.setErrorHandler((msg) {
      setState(() {
        speaking = false;
      });
    });
    await tts.speak(widget.speech);
  }
}
