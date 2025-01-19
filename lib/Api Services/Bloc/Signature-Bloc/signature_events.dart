import 'dart:io';

abstract class SignatureEvents {}

class SignatureCreatedEvent extends SignatureEvents {
  final String orderId;
  final File imagefile;
  SignatureCreatedEvent({required this.orderId, required this.imagefile});
}

class ReciverSignatureCreatedEvent extends SignatureEvents {
  final String orderId;
  final File imagefile;
  ReciverSignatureCreatedEvent(
      {required this.orderId, required this.imagefile});
}
