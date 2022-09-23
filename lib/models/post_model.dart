class PostModel {
  String? name;
  String? uId;
  String? profileImage;
  String? text;
  String? postImage;
  String? dateTime;
  String? postVideo;

  PostModel({
    this.name,
    this.uId,
    this.profileImage,
    this.text,
    this.dateTime,
    this.postImage,
    this.postVideo,
  });

  PostModel.fromJson(Map<String,dynamic>?json){
    name=json?['name'];
    uId=json?['uId'];
    profileImage=json?['image'];
    text=json?['text'];
    dateTime=json?['date'];
    postImage=json?['postImage'];
    postVideo=json?['postVideo'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'uId':uId,
      'image':profileImage,
      'text':text,
      'date':dateTime,
      'postImage':postImage,
      'postVideo':postVideo,
    };
  }
}