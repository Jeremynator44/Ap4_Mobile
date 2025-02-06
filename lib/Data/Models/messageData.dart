// lib/models/message_data.dart
class MessageData {
  final int idMessage;
  final int idEmploye;
  final String content;
  final DateTime dateMessage;
  final Map<String, dynamic>? cuisinier;

  MessageData({
    required this.idMessage,
    required this.idEmploye,
    required this.content,
    required this.dateMessage,
    this.cuisinier,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      idMessage: json['IDMESSAGE'],
      idEmploye: json['IDEMPLOYE'],
      content: json['CONTENT'],
      dateMessage: DateTime.parse(json['DATEMESSAGE']),
      cuisinier: json['c_u_i_s_i_n_i_e_r'],
    );
  }
}