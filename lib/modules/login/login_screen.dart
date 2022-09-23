// import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:social_app/layout/layout_screen.dart';
// import 'package:social_app/shared/components/constants.dart';
// import 'package:social_app/shared/network/local/cache_helper.dart';
// import '../../shared/components/components.dart';
// import '../../shared/styles/colors.dart';
// import '../register/register_screen.dart';
// import 'cubit/cubit.dart';
// import 'cubit/states.dart';
//
// //zeaadayman@gmail.com
// // ignore: must_be_immutable
// class LoginScreen extends StatelessWidget {
//   LoginScreen({Key? key}) : super(key: key);
//   static String route = 'login_screen';
//
//   var emailController = TextEditingController();
//   var passController = TextEditingController();
//   var formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LoginCubit, LoginStates>(
//         listener: (context, state) {
//       if (state is LoginErrorState) {
//         showToast(message: state.error, state: ToastStates.ERROR);
//       } else if (state is LoginSuccessState) {
//         uId=state.uId;
//         CacheHelper.putData(key: 'uId', value: uId);
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const LayoutScreen()));
//       }
//     },
//         builder: (context, state) {
//       LoginCubit cubit = LoginCubit.get(context);
//       return SafeArea(
//         child: Scaffold(
//           body: Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
//                 child: Form(
//                   key: formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Image.asset('assets/images/login.png'),
//                       Text(
//                         "LOGIN",
//                         style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                               fontSize: 40,
//                             ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "login now to communicate with friends",
//                         style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                               color: Colors.grey,
//                             ),
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       defaultFormField(
//                         context: context,
//                         myController: emailController,
//                         type: TextInputType.emailAddress,
//                         validate: (String? value) {
//                           if (value!.isEmpty) {
//                             return "Email cannot be empty";
//                           } else {
//                             return null;
//                           }
//                         },
//                         label: "Email Address",
//                         prefix: Icons.email_outlined,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       defaultFormField(
//                           context: context,
//                           myController: passController,
//                           type: TextInputType.visiblePassword,
//                           validate: (String? value) {
//                             if (value!.isEmpty) {
//                               return "password cannot be empty";
//                             } else {
//                               return null;
//                             }
//                           },
//                           label: "Password",
//                           prefix: Icons.lock,
//                           isPassword: cubit.isVisible,
//                           suffix: cubit.visibleIcon,
//                           suffixPress: () {
//                             cubit.changePassVisibility();
//                           }),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       ConditionalBuilder(
//                         condition: state is! LoginLoadingState,
//                         builder: (_) => defaultButton(
//                           txt: "login",
//                           radius: 5,
//                           function: () {
//                             if (formKey.currentState!.validate()) {
//                               cubit.loginUser(
//                                   email: emailController.text,
//                                   password: passController.text);
//                             }
//                           },
//                         ),
//                         fallback: (_) => const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Don't have an account? ",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyText1!
//                                 .copyWith(fontSize: 15),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => RegisterScreen()));
//                             },
//                             child: const Text(
//                               "REGISTER",
//                               style: TextStyle(color: defaultColor),
//                             ),
//                           )
//                         ],
//                       ),
//                       IconButton(
//                           onPressed: () {
//                             cubit.signInWithGoogle();
//                           },
//                           icon: const Icon(Icons.mark_email_read))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
