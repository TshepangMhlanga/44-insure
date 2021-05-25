
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState  createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage>{
  final mainReference = FirebaseDatabase.instance.reference().child('Database');
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar:AppBar(
       backgroundColor: Colors.red,
         title: Text("Financial Background"),

     ),
     floatingActionButton: FloatingActionButton(
       onPressed: (){
         getPdfAndUpload();
       },
       child:Icon(Icons.add,color:Colors.white,),
    backgroundColor: Colors.red,
   ),
   );
  }
Future getPdfAndUpload() async{
    var rng = new Random();
    String randomName="";
    for(var i =0;i<20;i++)
      {
        print(rng.nextInt(100));
        randomName+=rng.nextInt(100).toString();
      }
    File file = await FilePicker.getFile(type:FileType.custom);
    String fileName ='${randomName}.pdf';
     savePdf(file.readAsBytesSync(), fileName);
  }

  savePdf(List<int> asset, String name) async{
  StorageReference reference = FirebaseStorage.instance.ref().child(name);
  StorageUploadTask uploadTask = reference.putData(asset);
  String url = await (await uploadTask.onComplete).ref.getDownloadURL();
  documentFileUpload(url);
  }
String CreateCryptoRandomString([int length = 32]) {

final Random _random = Random.secure();
var values = List<int>.generate(length,(i) => _random.nextInt(256));
return base64Url.encode(values);
}
  void documentFileUpload(String str) {
    var data ={
      "PDF": str,
      "FileName": "SUPPORTING DOCUMENTS",
    };
    mainReference.child(CreateCryptoRandomString()).set(data).then((v) {
      print("Store Sucessfully");
    });
        }
  }

