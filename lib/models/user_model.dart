class UserModel {
   String? name;
   String? email;
   String? uId;
   String? phone;
   String? bio;
   String? image;
   String? cover;
   bool? isEmailVerified=false;

   UserModel({
       this.name,
       this.email,
       this.phone,
       this.uId,
       this.bio,
       this.image,
       this.cover,
       this.isEmailVerified,
   });

   UserModel.fromJson(Map<String,dynamic>?json){
      name=json?['name'];
      email=json?['email'];
      phone=json?['phone'];
      uId=json?['uId'];
      image=json?['image'];
      bio=json?['bio'];
      cover=json?['cover'];
      isEmailVerified=json?['isEmailVerified'];
   }

   Map<String,dynamic> toMap(){
      return {
         'name':name,
         'email':email,
         'phone':phone,
         'uId':uId,
         'bio':bio,
        'image':image,
        'cover':cover,
        'isEmailVerified':isEmailVerified,
      };
   }
}