import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import 'components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'home_login.dart';

class HomeRegister extends StatefulWidget {
  const HomeRegister({Key? key}) : super(key: key);

  @override
  State<HomeRegister> createState() => _HomeRegisterState();
}

class _HomeRegisterState extends State<HomeRegister> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return BlocListener<LoginCubit,LoginStates>(
      listener: (context, state) {
        if (state is RegisterErrorState ) {
          showToast(message: state.error, state: ToastStates.ERROR);
        }
        else if (state is CreateUserErrorState ) {
          showToast(message: state.error, state: ToastStates.ERROR);
        }
        else if(state is CreateUserSuccessState){
          showToast(message:"Registered Successfully", state: ToastStates.SUCCESS);
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>const HomeLogin()));
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
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [BoxShadow(color: Colors.black87,offset: Offset(1, 1),blurRadius: 3)]
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(0.0375*width),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.deepPurple,fontSize: 24,fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 0.05*height,
                              ),
                              MyTextField(
                                myController: nameController,
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Enter Your Name';
                                  }else{
                                    return null;
                                  }
                                },
                                prefixIcon: Icons.person,
                                type: TextInputType.name,
                                hint: 'Enter Your Name',
                              ),
                              SizedBox(height: 0.04*height,),
                              MyTextField(
                                myController: emailController,
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Enter Your Email';
                                  }else{
                                    return null;
                                  }
                                },
                                prefixIcon: Icons.email_outlined,
                                type: TextInputType.emailAddress,
                                hint: 'Enter Your Email',
                              ),
                              SizedBox(height: 0.04*height,),
                              MyTextField(
                                myController: phoneController,
                                validate: (String? value){
                                  if(value!.isEmpty){
                                    return 'Enter a Phone Number';
                                  }else{
                                    return null;
                                  }
                                },
                                prefixIcon: Icons.phone_android_outlined,
                                type: TextInputType.phone,
                                hint: 'Enter Your Phone Number',
                              ),
                              SizedBox(height: 0.04*height,),
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
                              SizedBox(height: 0.04*height,),
                              ConditionalBuilder(
                                  condition: state is! RegisterLoadingState,
                                  builder: (context)=>Container(
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
                                          cubit.register(
                                              name: nameController.text,
                                              email:emailController.text,
                                              password: passController.text,
                                              phone: phoneController.text);
                                        }
                                      },
                                      child: const Text('Register',style:TextStyle(color: Colors.white,fontSize: 20),),

                                    ),
                                  ),
                                  fallback: (context)=>const Center(child: CircularProgressIndicator(),),),
                              SizedBox(height: 0.02*height,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        const Text("Have an Account?"),
                        TextButton(onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeLogin()));
                        }, child: const Text('Sign In',style: TextStyle(color: Colors.deepPurple),))
                      ],)
                  ],
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


