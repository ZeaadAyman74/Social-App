import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/login/home_register.dart';
import '../../layout/layout_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import 'components.dart';

class HomeLogin extends StatefulWidget {
  const HomeLogin({Key? key}) : super(key: key);

  @override
  State<HomeLogin> createState() => _HomeLoginState();
}

class _HomeLoginState extends State<HomeLogin> {
  var formKey=GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return BlocListener<LoginCubit,LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(message: state.error, state: ToastStates.ERROR);
        } else if (state is LoginSuccessState) {
          uId=state.uId;
          CacheHelper.putData(key: 'uId', value: uId);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LayoutScreen()));
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    decoration:  BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.deepPurple[800]!,
                        Colors.deepPurple,
                      ]),
                    ),
                    width: width,
                    height: height * .5,
                  ),
                ),
                Expanded(child: Container(color: Colors.white,))
              ],
            ),
            Transform.translate(
              offset:  Offset(-(.413*width), -(.0782*height)),
              child: Container(
                height: .313*height,
                decoration: BoxDecoration(
                  color: Colors.grey[200]?.withOpacity(.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Transform.translate(
              offset:  Offset(.475*width, -(.0039*height)),
              child: Container(
                height: 0.117*1280,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            BlocBuilder<LoginCubit,LoginStates>(
              builder: (context, state) {
                var cubit=LoginCubit.get(context);
              return  Positioned(
                left: width*.07,
                right:width*.06 ,
                top: height*.2,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(1, 3),blurRadius: 4)]
                        ),
                        child: Padding(
                          padding:  EdgeInsets.all(0.0375*width),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.deepPurple,fontSize: 24,fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 0.04*height,
                              ),
                              MyTextField(
                                myController: emailController,
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Enter an email';
                                  }else{
                                    return null;
                                  }
                                },
                                prefixIcon: Icons.email,
                                type: TextInputType.emailAddress,
                                hint: 'Enter Your Email',
                              ),
                              SizedBox(height: 0.025*height,),
                              MyTextField(
                                myController: passController,
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Enter a Password';
                                  }else{
                                    return null;
                                  }
                                },
                                prefixIcon: Icons.key,
                                type: TextInputType.visiblePassword,
                                hint: 'Enter Your Password',
                                isPassword: true,
                              ),
                              SizedBox(height: 0.015*height,),
                              const Align(alignment: Alignment.centerRight, child: Text('Forgot Password?')),
                              SizedBox(height: 0.025*height,),
                              ConditionalBuilder(
                                  condition:  state is! LoginLoadingState,
                                  builder: (context)=> Container(
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
                                      onPressed: (){
                                        if(formKey.currentState!.validate()){
                                          cubit.loginUser(email: emailController.text, password: passController.text);
                                        }
                                      },
                                      child: const Text('LOGIN',style:TextStyle(color: Colors.white,fontSize: 20),),

                                    ),
                                  ),
                                      // MyButton(
                                      // text: "LOGIN",
                                      // height: height,
                                      // function: (){
                                      //   if (formKey.currentState!.validate()) {
                                      //     cubit.loginUser(
                                      //         email: emailController.text,
                                      //         password: passController.text);
                                      //   }
                                      // }),
                                  fallback:(context)=> const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              ),
                              SizedBox(height: 0.025*height,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: const Color(0xffd8d8d8),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text(
                                    'or continue with',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(fontSize: 14, fontWeight: FontWeight.w300,color: const Color(0xffd8d8d8)),
                                  ),
                                  const  SizedBox(width: 5,),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: const Color(0xffd8d8d8),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.025*height,),
                              Container(
                                height: 0.06*height,
                                decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(color:Colors.black87 )
                                ),
                                child: MaterialButton(
                                  onPressed: (){
                                    cubit.signInWithGoogle();
                                  },
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:   [
                                      const Text('Sign in with Google',style:TextStyle(color: Colors.black87,fontSize: 18),),
                                      SizedBox(width: 0.03*width,),
                                      Image.asset('assets/images/google.png',scale: 1.5),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.025*height,),
                              Container(
                                height: 0.06*height,
                                decoration:   BoxDecoration(
                                  color: Colors.indigo[500],
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                ),
                                child: MaterialButton(
                                  onPressed: (){},
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:   [
                                      const Text('Sign in with Facebook',style:TextStyle(color: Colors.white,fontSize: 18),),
                                      SizedBox(width: 0.03*width,),
                                      Image.asset('assets/images/facebook.png',scale: 1.5),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.02*height,),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const Text("Don't have an Account?"),
                          TextButton(onPressed: (){
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeRegister()));
                          }, child: const Text('Sign up',style: TextStyle(color: Colors.deepPurple),))
                        ],),
                    ],
                  ),
                ),
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}


