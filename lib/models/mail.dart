class Mail {
  String id;
  String from;
  String to;
  // ignore: non_constant_identifier_names
  String reply_to;
  String date;
  String subject;
  String message;
  String attachments;

  Mail({
    required this.id,
    required this.from,
    required this.to,
    // ignore: non_constant_identifier_names
    required this.reply_to,
    required this.date,
    required this.subject,
    required this.message,
    required this.attachments,
  });

  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      reply_to: json['reply_to'],
      date: json['date'],
      subject: json['subject'],
      message: json['message'],
      attachments: json['attachments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'reply_to': reply_to,
      'date': date,
      'subject': subject,
      'message': message,
      'attachments': attachments,
    };
  }
}
