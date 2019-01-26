import 'dart:ui';

import 'package:flutter/material.dart';

class NoSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Opacity(
        opacity: 0.50,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                        child: Image.asset("icons/swipe.png", width: 50.0),
                      ),
                      Text(
                        "Move",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                        child: Image.asset("icons/zoom-in.png", width: 50.0),
                      ),
                      Text(
                        "Scale",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                        child: Image.asset(
                          "icons/tap.png",
                          width: 50.0,
                        ),
                      ),
                      Text("Highlight",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ])
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
