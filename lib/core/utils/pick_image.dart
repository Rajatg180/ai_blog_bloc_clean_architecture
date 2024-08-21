import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(xfile != null){
      print("picked");
      return File(xfile.path);
    }
    print("not");
    return null;
  } catch (e) {
    return null;
  }
}
