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
       this.name='Name',
       this.email,
       this.phone,
       this.uId,
       this.bio,
       this.image='https://scontent.fcai20-3.fna.fbcdn.net/v/t39.30808-6/274880215_2117840785046945_8522829344125607352_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=V1jJmk97SBoAX8oIZKb&tn=A_MaB1Q5nNywYMrJ&_nc_ht=scontent.fcai20-3.fna&oh=00_AT9Os79Mr5b91nhgX9C8Pqf7xq8oDHMFeKaEVV6hqznqVA&oe=62F611EE',
       this.cover= 'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg',
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