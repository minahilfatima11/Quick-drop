import 'dart:io';

abstract class OrderPlaceEvent {}

class SenderDetailEvent extends OrderPlaceEvent {
  final Map<String, dynamic> sender;

  SenderDetailEvent({required this.sender});
}

class ReciverDetailEvent extends OrderPlaceEvent {
  final Map<String, dynamic> reciever;

  ReciverDetailEvent({required this.reciever});
}

class PackDetailsEvent extends OrderPlaceEvent {
  final File imageFile;
  final String orderId;
  final String itemName;
  final String itemSize;
  final String itemWeight;
  final String itemType;
  final String itemCategory;
  final String deliveryReq;
  final String charges;

  PackDetailsEvent(
      {required this.imageFile,
      required this.orderId,
      required this.itemName,
      required this.itemSize,
      required this.itemWeight,
      required this.itemType,
      required this.itemCategory,
      required this.deliveryReq,
      required this.charges});
}

class FetchPackageDetailsEvent extends OrderPlaceEvent {
  final String orderId;

  FetchPackageDetailsEvent({required this.orderId});
}
