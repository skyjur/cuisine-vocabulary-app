import 'package:flutter/material.dart';

class SelectedTextBar extends StatelessWidget {
  SelectedTextBar(this.text, {@required this.onRemoveClick});

  final text;
  final VoidCallback onRemoveClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(200, 220, 220, 220)),
      child: Row(children: [
        Text(
          text,
          style: TextStyle(fontSize: 25.0),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: onRemoveClick,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    child: Icon(
                      Icons.close,
                      size: 30.0,
                      color: Colors.redAccent,
                    ))),
          ),
        )
      ]),
    );
  }
}
