import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(width, height * .7);
    path.lineTo(width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class MyTextField extends StatelessWidget {
  final String? hint;
  TextEditingController myController;
  TextInputType type;
  bool isPassword;
  IconData prefixIcon;

  String? Function(String? value) validate;

  MyTextField({
    Key? key,
    this.hint,
    this.isPassword = false,
    this.type = TextInputType.text,
    required this.myController,
    required this.validate,
    required this.prefixIcon,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color:Color(0xffd8d8d8))),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color:Color(0xffd8d8d8)),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color:Color(0xffd8d8d8))),
        hintText: hint ?? '',
        hintStyle: const TextStyle(color: Color(0xffd8d8d8)),
        prefixIcon: Icon(prefixIcon),
        prefixIconColor: const Color(0xffd8d8d8),
        contentPadding: const EdgeInsets.all(15),
      ),

      controller: myController,
      keyboardType: type,
      // TextInputType.multiline
      validator: validate,
      obscureText: isPassword,
    );
  }
}

class MyButton extends StatelessWidget {
  String text;
  void Function()? function;
  double height;

  MyButton({
    Key? key,
    required this.text,
    required function ,
    this.height=50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.06*height,
      width: double.infinity,
      decoration:  BoxDecoration(
        gradient:LinearGradient(colors: [
          Colors.deepPurple[900]!,
          Colors.deepPurple,
        ]),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(text,style:const TextStyle(color: Colors.white,fontSize: 20),),

      ),
    );
  }
}