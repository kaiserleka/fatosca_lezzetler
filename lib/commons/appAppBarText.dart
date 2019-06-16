import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../strings.dart';

class AppAppBarText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      Strings.appName,
      maxLines: 1,
    );
  }
}