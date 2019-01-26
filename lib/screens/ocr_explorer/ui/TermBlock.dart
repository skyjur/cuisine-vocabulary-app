import 'package:flutter/material.dart';
import 'package:foodvocabularyapp/dictionary.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:foodvocabularyapp/ui/usability/speech.dart';

class TermBlock extends StatelessWidget {
  TermBlock(this.term, this.query, this.dictionary);
  final Term term;
  final String query;
  final Dictionary dictionary;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // term.imageUrl != null
          //     ? Image.network(term.imageUrl, width: 300, height: 200)
          //     : Image.asset("icons/ban.png", width: 300, height: 200),
          Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: term.imageUrl != null
                        ? NetworkImage(term.imageUrl)
                        : AssetImage("icons/ban.png"))),
            child: null,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(term.term, style: TextStyle(fontSize: 25.0)),
                  Text(term.pinYin, style: TextStyle(fontSize: 15.0)),
                  SpeechSpeaker(speech: term.term, language: "zh-CN")
                ],
              ),
              Container(
                width: 300,
                child: MarkdownBody(
                  data: term.translation,
                  onTapLink: (href) {
                    _onTapLink(context, href);
                  },
                ),
              )
            ],
          ))
        ]);
  }

  void _onTapLink(BuildContext context, String href) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final popupTerm = dictionary.getTermByValue(href);
          if (popupTerm != null) {
            return AlertDialog(
              content: TermBlock(popupTerm, popupTerm.term, dictionary),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        });
  }

  void speak() {}
}
