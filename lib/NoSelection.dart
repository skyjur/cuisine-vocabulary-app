import 'dart:ui';

import 'package:flutter/material.dart';

class NoSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Image.asset("icons/zoom-in.png", width: 90),
                    ),
                    Text(
                      "Scale & move",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Image.asset(
                        "icons/tap.png",
                        width: 90,
                      ),
                    ),
                    Text("Select",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ])
            ],
          ),
        ),
      ),
    );
    ;
  }
}
