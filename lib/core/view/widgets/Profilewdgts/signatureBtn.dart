import 'package:flutter/material.dart';

import '../../../utils/conts/colors.dart';

class SignatureBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const SignatureBtn({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.appOrange
    ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(title,style: TextStyle(color: AppColors.appWhite),),
        ));
  }
}
