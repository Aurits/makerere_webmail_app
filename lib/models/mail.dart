import 'package:dio/dio.dart';

class Mail {
  String id;
  String from;
  String to;
  // ignore: non_constant_identifier_names
  String reply_to;
  String date;
  String subject;
  String message;
  String attachmentsName;
  String attachmentsUrl;

  Mail({
    required this.id,
    required this.from,
    required this.to,
    // ignore: non_constant_identifier_names
    required this.reply_to,
    required this.date,
    required this.subject,
    required this.message,
    required this.attachmentsName,
    required this.attachmentsUrl,
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
      attachmentsName: json['attachmentsName'],
      attachmentsUrl: json['attachmentsUrl'],
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
      'attachmentsName': attachmentsName,
      'attachmentsUrl': attachmentsUrl,
    };
  }

  // ignore: non_constant_identifier_names
  static Future<void> get_online_emails() async {
    // ignore: avoid_print
    print("Start....................");
    final dio = Dio();
    try {
      Response<dynamic> response = await dio.get(
        'https://www.lytelink.tech',
      );

      if (response.data == null) {
        // Handle the case where the response data is null
        return;
      }

      if (response.statusCode == 200) {
        // Continue processing the response as before
        dynamic data = response.data;

        // ignore: avoid_print
        print(data);

        // if (data.containsKey('articles')) {
        //   List<dynamic> articles = data['articles'];
        //   // ignore: unused_local_variable
        //   int i = 0;
        //   for (var x in articles) {
        //     i++;
        //     NewsModel article = NewsModel.fromJson(x);
        //     article.save();
        //     // print("Article $i: ${article.title}");
        //   }
        // } else {}
      } else {}
    } catch (error) {
      // Handle the error case
    }
  }
}
