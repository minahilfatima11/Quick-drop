abstract class OrderEvent {}

class FetchAllOrdersEvent extends OrderEvent {
  final int userId;

  FetchAllOrdersEvent(this.userId);
}

class FetchCompletedOrdersEvent extends OrderEvent {
  final int userId;

  FetchCompletedOrdersEvent(this.userId);
}

class FetchPickupPendingLoadedOrdersEvent extends OrderEvent {
  final int userId;

  FetchPickupPendingLoadedOrdersEvent(this.userId);
}

class FetchDeliveredOrdersEvent extends OrderEvent {
  final int userId;

  FetchDeliveredOrdersEvent(this.userId);
}

class FetchDeliveryPendingOrdersEvent extends OrderEvent {
  final int userId;

  FetchDeliveryPendingOrdersEvent(this.userId);
}

class FetchRecentOrdersEvent extends OrderEvent {
  final int userId;

  FetchRecentOrdersEvent(this.userId);
}

class FetchOrderDetailsEvent extends OrderEvent {
  final String orderNo;

  FetchOrderDetailsEvent(this.orderNo);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetchOrderDetailsEvent &&
          runtimeType == other.runtimeType &&
          orderNo == other.orderNo;

  @override
  int get hashCode => orderNo.hashCode;
}
