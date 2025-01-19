class OrderModel {
  int? orderId;
  String? orderNo;
  String? orderDate;
  String? orderTime;
  String? orderStatus;
  String? itemName;
  String? itemImageFileName;
  String? senderName;
  String? receiverName;
  String? itemImageUrl;

  OrderModel({
    this.orderId,
    this.orderNo,
    this.orderDate,
    this.orderTime,
    this.orderStatus,
    this.itemName,
    this.itemImageFileName,
    this.senderName,
    this.receiverName,
    this.itemImageUrl,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json["order_id"];
    orderNo = json["order_no"];
    orderDate = json["order_date"];
    orderTime = json["order_time"];
    orderStatus = json["order_status"];
    itemName = json["item_name"];
    itemImageFileName = json["item_image_fileName"];
    senderName = json["sender_name"];
    receiverName = json["receiver_name"];
    itemImageUrl = json["item_image_url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["order_id"] = orderId;
    _data["order_no"] = orderNo;
    _data["order_date"] = orderDate;
    _data["order_time"] = orderTime;
    _data["order_status"] = orderStatus;
    _data["item_name"] = itemName;
    _data["item_image_fileName"] = itemImageFileName;
    _data["sender_name"] = senderName;
    _data["receiver_name"] = receiverName;
    _data["item_image_url"] = itemImageUrl;
    return _data;
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'orderNo': orderNo,
      'orderDate': orderDate,
      'orderTime': orderTime,
      'orderStatus': orderStatus,
      'itemName': itemName,
      'itemImageFileName': itemImageFileName,
      'senderName': senderName,
      'receiverName': receiverName,
      'itemImageUrl': itemImageUrl,
    };
  }
}
