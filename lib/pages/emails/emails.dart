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
            //display emails from the local database if any
            Expanded(
              child: FutureBuilder<List<Mail>>(
                future: Mail.getItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].subject),
                            subtitle: Text(snapshot.data![index].message),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
