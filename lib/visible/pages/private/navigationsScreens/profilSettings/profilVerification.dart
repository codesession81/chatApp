import 'dart:io';

import 'package:example/data/consts/hiveBox/hive_boxes.dart';
import 'package:example/data/database/online/db_update_profile_data.dart';
import 'package:example/data/global/global_data.dart';
import 'package:example/data/models/member.dart';
import 'package:example/services/codeGenerator/code_generator.dart';
import 'package:example/services/media/images/cropp_image.dart';
import 'package:example/services/media/images/image_compressor.dart';
import 'package:example/services/media/images/image_from_device.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfilVerification extends StatefulWidget {
  final Member? currentUser;
  ProfilVerification({required this.currentUser});

  @override
  _ProfilVerificationState createState() => _ProfilVerificationState();
}

class _ProfilVerificationState extends State<ProfilVerification> {
  final DbUpdateProfileData _dbUpdateProfileData = DbUpdateProfileData();
  String? generatedCode;
  final ImageCompressor _imageCompressor = ImageCompressor();
  final PickImageFromDevice _pickImageFromDevice = PickImageFromDevice();
  final CroppImageFromDevice _croppImageFromDevice = CroppImageFromDevice();
  List<Member> listOfAllMembers = [];
  File? _file;
  String imagePath="";
  String? profilVerifiedCode;


  @override
  void initState() {
    super.initState();
    CodeGenerator.generateVerificationCode();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(HiveBoxes.allMembersBox).listenable(),
       builder: (context,box,_){
         listOfAllMembers = box.values.toList().cast<Member>();
         listOfAllMembers.forEach((member){
          if(member.uid== widget.currentUser?.uid){
            profilVerifiedCode = member.profilVerifiedCode;
          }
         });
        return  Scaffold(
          appBar:
           AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.lightGreen, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
              "Verifiziere Dein Profil",
              style: TextStyle(fontSize: 20, color: Colors.lightGreen),
            ),
      ),
      body: manageProfilVerifikationView(profilVerifiedCode: profilVerifiedCode)
    );
       }
       );
  }

  Widget manageProfilVerifikationView({String? profilVerifiedCode}){
    if(GlobalData.currentUser?.profilVerificationStatus=="offen"){
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 25),
            const Center(child: Text("Schreib Deinen Benutzernamen und folgenden Code auf einen Zettel",textAlign: TextAlign.center)),
            const SizedBox(height: 25),
            Center(
              child:Text("${GlobalData.currentUser?.profilVerifiedCode}",style: const TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold,fontSize: 30)),
            ),
            const SizedBox(height: 25),
            const Center(child: Text("und mach ein Foto wo Du mit dem Zettel alleine und deutlich zu sehen bist!",textAlign: TextAlign.center,),),
            const SizedBox(height: 25),
            Column(
              children: <Widget>[
                Center(
                  child: _file == null? const Icon(Icons.account_circle,size: 200,) : Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height*0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.file(
                                _file!,
                                fit: BoxFit.fill,
                              ).image,

                          )
                      )),
                ),
                const SizedBox(height: 25.0),
                Row(
                  children: <Widget>[
                    Expanded (
                      flex:5,
                      child : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            onPressed: ()async{
                              File receivedImageFromGallerieOrCamera = await _pickImageFromDevice.pickSingleImageFromGallerieOrCamera(ImageSource.gallery);
                              setState(() {
                                _file = receivedImageFromGallerieOrCamera;
                              });
                            },
                            backgroundColor: Colors.lightGreen,
                            heroTag: "btn1",
                            child: const Icon(Icons.photo_library),
                          ),
                          const Text("Gallerie")
                        ],
                      ),),
                    Expanded(
                      flex :5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            onPressed:()async{
                              File receivedImageFromGallerieOrCamera = await _pickImageFromDevice.pickSingleImageFromGallerieOrCamera(ImageSource.camera);
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
                      ),)
                  ],
                ),
                const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _file == null? Text(""):
                    ElevatedButton(
                      onPressed: ()async{
                        File? compressedFile = (await _imageCompressor.compressFile(_file!));
                        _dbUpdateProfileData.uploadProfilVerificationImage(GlobalData.currentUser?.uid, compressedFile);
                        _dbUpdateProfileData.setProfilVerificationState();
                        Navigator.pop(context);
                      },
                      child: const Text('weiter'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 150.0),
          ],
        ),
      );
    }else if(GlobalData.currentUser?.profilVerificationStatus=="check"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SizedBox(height: 50),
          Center(child: Text("Wir prüfen Deine Anfrage und bitten um etwas Geduld!",textAlign: TextAlign.center,style: TextStyle(color: Colors.orange,fontSize: 25),))
        ],
      );
    }else if(GlobalData.currentUser?.profilVerificationStatus=="abgelehnt"){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(height: 25),
          const Center(child: Text("Das hat leider nicht geklappt, versuch es bitte erneut und vermeide z.b ein spiegelverkehrtes Foto!",textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20))),
          const SizedBox(height: 25),
          const Center(child: Text("Schreib folgenden Code auf einen Zettel")),
          const SizedBox(height: 25),
          Center(
            child: Text("${GlobalData.currentUser?.profilVerifiedCode}",style: const TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.bold,fontSize: 30)),
          ),
          const SizedBox(height: 25),
          const Center(child: Text("und mach ein Foto wo Du und der Zettel mit dem Code alleine und deutlich zu sehen bist!",textAlign: TextAlign.center,),),
          Column(
            children: <Widget>[
              Center(
                child: _file == null? const Icon(Icons.account_circle,size: 200,) : CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 100,
                  child: CircleAvatar(
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
                  Expanded (
                    flex:5,
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: ()async{
                            File receivedImageFromGallerieOrCamera = await _pickImageFromDevice.pickSingleImageFromGallerieOrCamera(ImageSource.gallery);
                            setState(() {
                              _file = receivedImageFromGallerieOrCamera;
                            });
                          },
                          backgroundColor: Colors.lightGreen,
                          heroTag: "btn1",
                          child: const Icon(Icons.photo_library),
                        ),
                        const Text("Gallerie")
                      ],
                    ),),
                  _file==null?Text(""): Expanded (
                    flex:5,
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed: ()async{
                            File receivedCroppedImage = await _croppImageFromDevice.imageCropper(_file!);
                            setState(() {
                              _file = receivedCroppedImage;
                            });
                          },
                          backgroundColor: Colors.lightGreen,
                          heroTag: "btn2",
                          child: const Icon(Icons.crop),
                        ),
                        const Text("Ausrichten")
                      ],
                    ),),
                  Expanded(
                    flex :5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          onPressed:()async{
                            File receivedImageFromGallerieOrCamera = await _pickImageFromDevice.pickSingleImageFromGallerieOrCamera(ImageSource.camera);
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
                    ),)
                ],
              ),
              const SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _file == null? Container():
                    ElevatedButton(
                      onPressed: ()async{
                        File? compressedFile = (await _imageCompressor.compressFile(_file!));
                        _dbUpdateProfileData.uploadProfilVerificationImage(GlobalData.currentUser?.uid, compressedFile);
                        _dbUpdateProfileData.setProfilVerificationState();
                        Navigator.pop(context);
                      },
                      child: const Text('weiter'),
                    ),
                ],
              ),
            ],
          )
        ],
      );
    }else{
     return Container();
    }
  }
}
