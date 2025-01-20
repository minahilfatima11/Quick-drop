import 'package:flutter/material.dart';

import '../../../utils/conts/colors.dart';

class SenderReceiverSection extends StatelessWidget {
  final String senderName;
  final String receiverName;

  const SenderReceiverSection({
    Key? key,
    required this.senderName,
    required this.receiverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sender Name',
              style: TextStyle(fontSize: 11,  color: Colors.grey),
            ),
            Text(
              senderName,
              style:  TextStyle(fontSize: 12, fontWeight: FontWeight.bold , color: AppColors.appOrange),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Receiver Name',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              receiverName,
              style:  TextStyle(fontSize: 12, fontWeight: FontWeight.bold , color: AppColors.appOrange),
            ),
          ],
        ),
      ],
    );
  }
}
