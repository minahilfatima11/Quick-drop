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
              style: TextStyle(fontSize: 14,  color: AppColors.appOrange.withOpacity(0.7)),
            ),
            Text(
              senderName,
              style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold , color: AppColors.appOrange),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Receiver Name',
              style: TextStyle(fontSize: 14, color: AppColors.appOrange.withOpacity(0.7)),
            ),
            Text(
              receiverName,
              style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold , color: AppColors.appOrange),
            ),
          ],
        ),
      ],
    );
  }
}
