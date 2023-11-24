import 'package:dio/dio.dart';
import 'package:makerere_webmail_app/utils/database.dart';
import 'package:sqflite/sqflite.dart';

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

  static Future<List<Mail>> getItems() async {
    List<Mail> items = await get_local_emails();
    if (items.isEmpty) {
      await get_online_emails();
      items = await get_local_emails();
    } else {
      get_online_emails();
      items = await get_local_emails();
    }
    return items;
  }

  // ignore: non_constant_identifier_names
  static Future<void> get_online_emails() async {
    // ignore: avoid_print
    print("Started....................");
    final dio = Dio();
    try {
      Response<dynamic> response = await dio.get(
        'http://10.1.3.216:8000/api/fetch-emails',
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

        if (data.containsKey('articles')) {
          List<dynamic> articles = data['articles'];
          // ignore: unused_local_variable
          int i = 0;
          for (var x in articles) {
            i++;
            Mail article = Mail.fromJson(x);
            article.save();
            // print("Article $i: ${article.title}");
          }
        } else {}
      } else {}
    } catch (error) {
      // Handle the error case
    }
  }

  //save to the local db
  Future<String> save() async {
    Database db = await Utils.init();
    String resp = await init_table(db);

    // ignore: avoid_print
    print(resp);

    if (resp.isNotEmpty) {
      try {
        await db.insert(
          'news',
          toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        // ignore: avoid_print
        print("Saved successfully");
      } catch (e) {
        resp = "Failed to save to the db ${e.toString()}";
        // ignore: avoid_print
        print("Failed db save");
      }

      // ignore: avoid_print
      print("table created");
      return "table created";
    } else {
      // ignore: avoid_print
      print("table not created");
      return "table not created";
    }
  }

  // ignore: non_constant_identifier_names
  static Future<String> init_table(Database db) async {
    String resp = '';
    // ignore: unnecessary_null_comparison
    if (db == null) {
      resp = 'Failed to initialise the db';
    }

    try {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS news (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT, urlToImage TEXT, source TEXT, author TEXT, title TEXT, description TEXT, publishedAt TEXT, content TEXT)');
      resp = 'TABLE CREATED SUCCESSFULLY';
    } catch (e) {
      resp = 'FAILED TO INSERT INTO THE DB';
    }
    return resp;
  }

  // ignore: non_constant_identifier_names
  static Future<List<Mail>> get_local_emails({String where = "1"}) async {
    Database db = await Utils.init();
//init_table
    Mail.init_table(db);
    return db
        .query(
      'news',
      where: where,
    )
        .then(
      (value) {
        List<Mail> items = [];
        for (var x in value) {
          items.add(Mail.fromJson(x));
        }
        return items;
      },
    );
  }
}
