class CommentModel {
  String? name;
  String? uId;
  String? profileImage;
  String? comment;
  String? dateTime;

CommentModel({
   this.name,
  this.uId,
  this.dateTime,
  this.comment,
  this.profileImage,
});

CommentModel.fromJson(Map<String,dynamic>json){
  name=json['name'];
  uId=json['uId'];
  profileImage=json['profileImage'];
  comment=json['comment'];
  dateTime=json['dateTime'];
  }

  Map<String,dynamic> toMap(){
  return {
    'name':name,
    'uId':uId,
    'profileImage':profileImage,
    'comment':comment,
    'dateTime':dateTime,
  };
  }
}