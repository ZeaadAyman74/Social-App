// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:social_app/models/user_model.dart';
// import 'package:social_app/modules/register/cubit/states.dart';
// import '../../../shared/components/components.dart';
//
// class RegisterCubit extends Cubit<RegisterStates> {
//   RegisterCubit() : super(RegisterInitialState());
//
//   static RegisterCubit get(context) => BlocProvider.of(context);
//
//   bool isVisible = true;
//   var visibleIcon = Icons.visibility;
//
//   void changePassVisibility() {
//     if (isVisible == true) {
//       visibleIcon = Icons.visibility_off;
//       isVisible = false;
//       emit(ChangePassVisibilityState());
//     } else {
//       visibleIcon = Icons.visibility;
//       isVisible = true;
//       emit(ChangePassVisibilityState());
//     }
//   }
//
//   void register({
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//   })async{
//     emit(RegisterLoadingState());
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
//       await  createUser(name: name, email: email, uId: value.user!.uid, phone: phone);
//         emit(RegisterSuccessState());
//       });
//     }on FirebaseAuthException catch(error){
//       if(error.code=='weak-password'){
//         showToast(message: 'weak-password', state: ToastStates.ERROR);
//       }else if(error.code=='email-already-in-use'){
//         showToast(message: 'email-already-in-use', state: ToastStates.ERROR);
//       }
//     }catch(error){
//       print(error);
//       emit(RegisterErrorState(error.toString()));
//     }
//   }
//
//  Future<void>createUser({
//     required String name,
//     required String email,
//     required String uId,
//     required String phone,
// })async {
//     emit(CreateUserLoadingState());
//     UserModel userData=UserModel(
//         name: name,
//         email: email,
//         phone: phone,
//         uId: uId,
//         isEmailVerified: false,
//         image: 'https://scontent.fcai20-3.fna.fbcdn.net/v/t39.30808-6/274880215_2117840785046945_8522829344125607352_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=V1jJmk97SBoAX8oIZKb&tn=A_MaB1Q5nNywYMrJ&_nc_ht=scontent.fcai20-3.fna&oh=00_AT9Os79Mr5b91nhgX9C8Pqf7xq8oDHMFeKaEVV6hqznqVA&oe=62F611EE',
//         cover: 'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg',
//         bio: 'write your bio ...',
//     );
//    await FirebaseFirestore.instance.collection('users').doc(uId).set(userData.toMap()).then((value) {
//       emit(CreateUserSuccessState());
//     }).catchError((error){
//       print(error.toString());
//       emit(CreateUserErrorState(error.toString()));
//     });
//
//   }
//
// }
