import 'package:flutter/material.dart';

class RequestUserData extends StatefulWidget {
  const RequestUserData({super.key});

  @override
  State<RequestUserData> createState() => _RequestUserDataState();
}

class _RequestUserDataState extends State<RequestUserData> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
           const Text("Zugangsdaten vergessen?",style: TextStyle(fontSize: 20.0,color: Colors.lightGreen),),
                      const SizedBox(height:25.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Deine Emailadresse',
                          ),
                        ),
                      ),
                      const SizedBox(height:25.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: () async {

                          },
                          backgroundColor: Colors.red,
                          label: const Text("Zugangsdaten anfordern"),
                        ),
                      ),
        ],
      ),
    );
  }
}