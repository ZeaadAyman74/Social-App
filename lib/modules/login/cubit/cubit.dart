import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import '../../../models/user_model.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  bool isVisible = true;
  var visibleIcon = Icons.visibility;
  dynamic changePassVisibility() {
    if (isVisible == true) {
      visibleIcon = Icons.visibility_off;
      isVisible = false;
      emit(ChangePassVisibilityState());
    } else {
      visibleIcon = Icons.visibility;
      isVisible = true;
      emit(ChangePassVisibilityState());
    }
  }

  void register({
    required String name,
    required String email,
    required String password,
    required String phone,
  })async{
    emit(RegisterLoadingState());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
        await  createUser(name: name, email: email, uId: value.user!.uid, phone: phone);
        emit(RegisterSuccessState());
      });
    }on FirebaseAuthException catch(error){
      if(error.code=='weak-password'){
        showToast(message: 'weak-password', state: ToastStates.ERROR);
      }else if(error.code=='email-already-in-use'){
        showToast(message: 'email-already-in-use', state: ToastStates.ERROR);
      }
    }catch(error){
      print(error);
      emit(RegisterErrorState(error.toString()));
    }
  }

  Future<void> loginUser({required String email, required String password}) async {
    emit(LoginLoadingState());
    try{
      await  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
        print('${value.user!.uid}/////////////////////////////////////');
        emit(LoginSuccessState(value.user!.uid));
      });
    }on FirebaseAuthException catch(error){
      if(error.code=='user-not-found'){
        showToast(message: 'user-not-found', state: ToastStates.ERROR);
        emit(LoginErrorState(error: error.toString()));
      }else if(error.code=='wrong-password'){
        showToast(message: 'wrong-password', state: ToastStates.ERROR);
        emit(LoginErrorState(error: error.toString()));
      }
      }catch(error){
      emit(LoginErrorState(error: error.toString()));
    }
  }

  signInWithGoogle()async{
    final GoogleSignInAccount? googleUser=await GoogleSignIn(scopes: <String>["email"]).signIn();
    final GoogleSignInAuthentication googleAuth=await googleUser!.authentication;
    final credential=GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken:googleAuth.idToken );
   await FirebaseAuth.instance.signInWithCredential(credential).then((value) async{
    final user= FirebaseAuth.instance.currentUser;

    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').where('email',isEqualTo:user!.email).get();
    if (query.docs.isEmpty){
      await  createUser(
        name: user.displayName!,
        email: user.email!,
        uId: user.uid,
        image: user.photoURL,
      );    }
     emit(LoginSuccessState(user.uid));
   });
  }

  Future<void>createUser({
    required String name,
    required String email,
    required String uId,
     String? phone,
    String? image,
    String? cover,
  })async {
    emit(CreateUserLoadingState());
    UserModel userData=UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isEmailVerified: false,
      image:image?? 'https://scontent.fcai20-3.fna.fbcdn.net/v/t39.30808-6/274880215_2117840785046945_8522829344125607352_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=V1jJmk97SBoAX8oIZKb&tn=A_MaB1Q5nNywYMrJ&_nc_ht=scontent.fcai20-3.fna&oh=00_AT9Os79Mr5b91nhgX9C8Pqf7xq8oDHMFeKaEVV6hqznqVA&oe=62F611EE',
      cover:cover?? 'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg',
      bio: 'write your bio ...',
    );
    await FirebaseFirestore.instance.collection('users').doc(uId).set(userData.toMap()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(CreateUserErrorState(error.toString()));
    });

  }

  Future<void>logout()async {
   await CacheHelper.removeValue(key: 'uId');
    await FirebaseAuth.instance.signOut();
    emit(LogoutSuccessState());
  }
}
