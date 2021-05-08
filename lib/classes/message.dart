class Message{
  final String message;
  //el id es del Doc de Conversation
  final String idConversation;
  final DateTime date;
  final String uidSender;

  Message({this.message, this.idConversation, this.date, this.uidSender});
}