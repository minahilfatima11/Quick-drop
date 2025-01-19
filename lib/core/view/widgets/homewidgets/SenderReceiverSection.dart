import 'package:flutter/material.dart';

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
            const Text(
              'Sender Name',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              senderName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Receiver Name',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              receiverName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
