class MessageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  String? audioMsg;

  MessageModel({
    this.text,
    this.receiverId,
    this.senderId,
    this.dateTime,
    this.audioMsg,
});
  MessageModel.fromJson(Map<String,dynamic>json){
    senderId=json['senderId'];
    receiverId=json['receiverId'];
    dateTime=json['dateTime'];
    text=json['text'];
    audioMsg=json['audioMsg'];
  }

 Map<String,dynamic> toMap(){
    return{
      'senderId':senderId,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'text':text,
      'audioMsg':audioMsg,
    };
  }
}