import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../cubit/social_cubit.dart';
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

Widget defaultFormField({
  required BuildContext context,
  required TextEditingController myController,
  required TextInputType type,
  required String? Function(String? value) validate,
  required String label,
  required IconData prefix,
  Function(String value)? onSubmit,
  Function(String value)? onChange,
  IconData? suffix,
  Function()? suffixPress,
  bool isPassword = false,
  void Function()? onTap,
  bool isBorder = false,
  double radius = 0,
}) =>
    TextFormField(
      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
      controller: myController,
      keyboardType: type,
      validator: validate,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      decoration: InputDecoration(
        // labelText: label,
        //labelStyle: const TextStyle(color: defaultColor),
        hintText: label,
        hintStyle:
            Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 15),
        prefixIcon: Icon(prefix,
            color:
                SocialCubit.get(context).isDark ? Colors.white : defaultColor),
        suffixIcon: IconButton(
          icon: Icon(
            suffix,
            color:
                SocialCubit.get(context).isDark ? Colors.white : defaultColor,
          ),
          onPressed: suffixPress,
          color: SocialCubit.get(context).isDark ? Colors.white : Colors.black,
        ),

        border: isBorder
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal))
            : null,
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
