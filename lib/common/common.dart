import 'package:flutter/material.dart';

InputDecoration dropDownDecoration({String hintText}) {
  return InputDecoration(
    filled: true,
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.black38),
    fillColor: Colors.grey[200],
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorStyle: TextStyle(height: 0, color: Colors.transparent),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
