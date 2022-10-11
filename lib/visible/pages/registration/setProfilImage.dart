import 'dart:io';

import 'package:example/services/media/images/cropp_image.dart';
import 'package:example/services/media/images/image_compressor.dart';
import 'package:example/services/media/images/image_from_device.dart';
import 'package:example/services/permissions/permission_manager.dart';
import 'package:example/visible/pages/registration/setPassword.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetProfilImage extends StatefulWidget {
  final String? age;
  final String? email;
  final String? gender;
  final String? town;
  final String? username;
  SetProfilImage(
      {required this.email,
      required this.username,
      required this.age,
      required this.gender,
      required this.town,
      });

  @override
  _SetProfilImageState createState() => _SetProfilImageState();
}

class _SetProfilImageState extends State<SetProfilImage> {
  final PermissionManager _permissionManager = PermissionManager();
  final ImageCompressor _imageCompressor = ImageCompressor();
  final PickImageFromDevice _pickImageFromDevice = PickImageFromDevice();
  final CroppImageFromDevice _croppImageFromDevice = CroppImageFromDevice();

  File? _file;
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    _permissionManager.getPermissionState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        title:  const Text(
          "Schritt 6/7",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.lightGreen),
        ),
      ),
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50.0),
            _file == null
                ? const Text(
              "Wähle ein Profilfoto",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey),
            ):Container(),
            const SizedBox(height: 25.0),
            Center(
              child: _file == null
                  ? const Icon(
                      Icons.account_circle,
                      size: 200,
                      color: Colors.lightGreen,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 100,
                      child: CircleAvatar(
                        radius: 200 - 5,
                        backgroundImage: Image.file(
                          _file!,
                          fit: BoxFit.cover,
                        ).image,
                      ),
                    ),
            ),
            const SizedBox(height: 25.0),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () async {
                          File receivedImageFromGallerieOrCamera =
                              await _pickImageFromDevice
                                  .pickSingleImageFromGallerieOrCamera(
                                      ImageSource.gallery);
                          setState(() {
                            _file = receivedImageFromGallerieOrCamera;
                          });
                        },
                        backgroundColor: Colors.lightGreen,
                        heroTag: "btn1",
                        child: Icon(Icons.photo_library),
                      ),
                      Text("Gallerie")
                    ],
                  ),
                ),
                _file == null
                    ? const Text("")
                    : Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              onPressed: () async {
                                File receivedCroppedImage =
                                    await _croppImageFromDevice
                                        .imageCropper(_file!);
                                setState(() {
                                  _file = receivedCroppedImage;
                                });
                              },
                              backgroundColor: Colors.lightGreen,
                              heroTag: "btn2",
                              child: Icon(Icons.crop),
                            ),
                            Text("Ausrichten")
                          ],
                        ),
                      ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () async {
                          File receivedImageFromGallerieOrCamera =
                              await _pickImageFromDevice
                                  .pickSingleImageFromGallerieOrCamera(
                                      ImageSource.camera);
                          setState(() {
                            _file = receivedImageFromGallerieOrCamera;
                          });
                        },
                        backgroundColor: Colors.lightGreen,
                        heroTag: "btn3",
                        child: const Icon(Icons.camera_alt),
                      ),
                      const Text("Kamera")
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _file == null
                    ? const Text("")
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: () async {
                            File? compressedFile = (await _imageCompressor.compressFile(_file!));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SetPassword(
                                  email: widget.email,
                                  username: widget.username,
                                  file: compressedFile,
                                  age: widget.age,
                                  gender: widget.gender,
                                  town: widget.town,
                                ),
                              ),
                            );
                          },
                          backgroundColor: Colors.lightGreen,
                          label: const Text("weiter"),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
