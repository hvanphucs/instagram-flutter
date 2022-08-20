import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools show log;

Future<Uint8List?> pickImage(ImageSource source) async {
  try {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      return await image.readAsBytes();
    }
  } catch (e) {
    devtools.log(e.toString());
    devtools.log('No Image selected');
  }
  return null;
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}
