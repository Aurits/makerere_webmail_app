// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:makerere_webmail_app/utils/database.dart';
import 'package:sqflite/sqflite.dart';

class Mail {
  String id;
  String froms;
  String tos;
  String replyTo;
  String date;
  String subject;
  String message;
  String attachmentsName;
  String attachmentsUrl;

  // Constructor for Mail object
  Mail({
    required this.id,
    required this.froms,
    required this.tos,
    required this.replyTo,
    required this.date,
    required this.subject,
    required this.message,
    required this.attachmentsName,
    required this.attachmentsUrl,
  });

  // Factory method to create Mail object from JSON data
  factory Mail.fromJson(Map<String, dynamic> json) {
    return Mail(
      id: json['id'] ?? '',
      froms: json['from'] ?? '',
      tos: json['to'] ?? '',
      replyTo: json['reply_to'] ?? '',
      date: json['date'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      attachmentsName: json['attachmentsName'] ?? '',
      attachmentsUrl: json['attachmentsUrl'] ?? '',
    );
  }

  // Convert Mail object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': froms,
      'to': tos,
      'reply_to': replyTo,
      'date': date,
      'subject': subject,
      'message': message,
      'attachmentsName': attachmentsName,
      'attachmentsUrl': attachmentsUrl,
    };
  }

  // Get emails, first from local storage, then online if local is empty
  static Future<List<Mail>> getItems() async {
    List<Mail> emails = await getLocalEmails();
    if (emails.isEmpty) {
      await getOnlineEmails();
      emails = await getLocalEmails();
    } else {
      getOnlineEmails();
      emails = await getLocalEmails();
    }
    print(emails);
    return emails;
  }

  // Fetch emails from the online API
  static Future<void> getOnlineEmails() async {
    final dio = Dio();
    try {
      Response<dynamic> response = await dio.get(
        'http://10.150.32.126:8000/api/fetch-emails',
      );

      if (response.statusCode == 200) {
        dynamic data = response.data;

        print(data);

        if (data.containsKey('emails')) {
          List<dynamic> emails = data['emails'];
          // ignore: unused_local_variable
          int i = 0;
          for (var x in emails) {
            i++;
            Mail emails = Mail.fromJson(x);
            emails.save();
          }
        }
      }
    } catch (error) {
      // Handle the error case
      print("Error fetching online emails: $error");
    }
  }

  // Save email to local database
  Future<void> save() async {
    Database db = await Utils.init();
    String resp = await initTable(db);

    print(resp);

    if (resp.isNotEmpty) {
      print("start......");
      try {
        await db.insert(
          'emails',
          toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("Saved successfully");
      } catch (e) {
        print("Failed db save: $e");
      }
    } else {
      print("Table not created");
    }
  }

  // Initialize the database table
  static Future<String> initTable(Database db) async {
    String resp = '';

    if (db == null) {
      resp = 'Failed to initialize the db';
      print(resp);
      return resp;
    }

    try {
      //DELETE TABLE
      //await db.execute('''DROP TABLE IF EXISTS emails''');
      await db.execute('''
                  CREATE TABLE IF NOT EXISTS emails (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    froms TEXT,  -- Enclose problematic column names in square brackets
                    tos TEXT,
                    reply_to TEXT,
                    date TEXT,
                    subject TEXT,
                    message TEXT,
                    attachmentsName TEXT,
                    attachmentsUrl TEXT
                  )
                ''');

      resp = 'Table created successfully';
      print(resp);
    } catch (e) {
      resp = 'Failed to create table in the db: ${e.toString()}}';
      print(resp);
    }
    return resp;
  }

  // Get local emails from the database
  static Future<List<Mail>> getLocalEmails({String where = "1"}) async {
    Database db = await Utils.init();
    await initTable(db);

    return db.query('emails', where: where).then((value) {
      List<Mail> emails = [];
      for (var x in value) {
        emails.add(Mail.fromJson(x));
      }
      return emails;
    });
  }

  //TO DISPLAY THE NAME OF THE EMAIL IN THE DATABASE BY PRINT
  static void displayEmails() async {
    List<Mail> emails = await getLocalEmails();
    for (var x in emails) {
      print(x.subject);
    }
  }
}
