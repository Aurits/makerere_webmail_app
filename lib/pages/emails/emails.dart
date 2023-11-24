import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makerere_webmail_app/models/mail.dart';

class EmailsPage extends StatefulWidget {
  const EmailsPage({super.key});

  @override
  State<EmailsPage> createState() => _EmailsPageState();
}

class _EmailsPageState extends State<EmailsPage> {
  List<Mail> emails = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    Mail.getOnlineEmails().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: Mail.getOnlineEmails,
                  child: Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
                Text("Emails",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            //display number of emails in the db
          ],
        ),
      ),
    );
  }
}
