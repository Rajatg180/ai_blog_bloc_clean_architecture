import 'package:flutter/material.dart';

// show newsnackbar and hidde prev snackbar
void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(content),
    ),
  );
}
