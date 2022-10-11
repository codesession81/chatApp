
import 'package:example/visible/pages/private/navigationsScreens/profilSettings/updateEmail.dart';
import 'package:example/visible/pages/private/navigationsScreens/profilSettings/updatePassword.dart';
import 'package:flutter/material.dart';

class ProfilSettings extends StatefulWidget {
  @override
  _ProfilSettingsState createState() => _ProfilSettingsState();
}

class _ProfilSettingsState extends State<ProfilSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profileinstellungen",style:TextStyle(color: Colors.lightGreen)),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 25),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.lightGreen,
                        radius: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.alternate_email, size: 40),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateEmail(),
                              ),
                            );
                          },
                        ),
                      ),
                      const Text("Neue Emailadresse"),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.lightGreen,
                        radius: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.lock, size: 40),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePassword(),
                              ),
                            );
                          },
                        ),
                      ),
                      const Text("Neues Password"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
