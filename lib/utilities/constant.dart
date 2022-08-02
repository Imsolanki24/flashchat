import 'package:flutter/material.dart';

const String defaultImage =
    "https://firebasestorage.googleapis.com/v0/b/openiot-dev.appspot.com/o/profileImage%2FHdBaAd8mBuTvUUfbe2DcJIRHcNF2.png?alt=media&token=3b875374-f08c-41e4-a192-c9f638e51ea3";

const kInputDecoration = InputDecoration(
    hintText: 'Enter a Value',
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(32),
      ),
    ),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        )),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(32))));

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
