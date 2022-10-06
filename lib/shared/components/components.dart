import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../styles/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = defaultColor,
  Color foreColor = Colors.white,
  bool isUpperCase = true,
  required String txt,
  required Function() function,
  double radius = 0.0,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? txt.toUpperCase() : txt,
          style: TextStyle(fontSize: 17, color: foreColor),
        ),
      ),
    );


void showToast({required String message, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, WARNING, ERROR }

Color chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.ERROR:
      return Colors.red;
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.WARNING:
      return Colors.amber;
  }
}

String? Function(String? value) validationFunction({
      required String myValue,
      required String message
    }) {
  return (myValue) {
    if (myValue!.isEmpty) {
      return message;
    } else {
      return null;
    }
  };
}
