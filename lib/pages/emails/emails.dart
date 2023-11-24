import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makerere_webmail_app/models/mail.dart';

class EmailsPage extends StatefulWidget {
  const EmailsPage({super.key});

  @override
  State<EmailsPage> createState() => _EmailsPageState();
}

class _EmailsPageState extends State<EmailsPage> {
  List<Mail> emails = [
    Mail(
      id: '1',
      from: 'from',
      to: 'to',
      replyTo: 'replyTo',
      date: 'date',
      subject: 'subject',
      message: 'message',
      attachmentsName: 'attachmentsName',
      attachmentsUrl: 'attachmentsUrl',
    ),
  ];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  // Function to load emails
  Future<void> _loadEmails() async {
    List<Mail> fetchedEmails = await Mail.getItems();
    setState(() {
      emails = fetchedEmails;
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
                  onTap: Mail.getOnlineEmails, // Refresh button
                  child: Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
                Text(
                  "Emails",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // Display emails
            Expanded(
              child: ListView.builder(
                itemCount: emails.length,
                itemBuilder: (BuildContext context, int index) {
                  Mail email = emails[index];
                  // Customize the ListTile according to your email model
                  return ListTile(
                    title: Text(email.subject),
                    subtitle: Text(email.from),
                    // Add more details as needed
                  );
                },
              ),
            ),
            //display number of emails
            Text(
              "You have ${emails.length} emails",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
