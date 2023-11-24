import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makerere_webmail_app/models/mail.dart';

class EmailsPage extends StatefulWidget {
  const EmailsPage({super.key});

  @override
  State<EmailsPage> createState() => _EmailsPageState();
}

class _EmailsPageState extends State<EmailsPage> {
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
                  onTap: Mail.get_online_emails,
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
          ],
        ),
      ),
    );
  }
}
