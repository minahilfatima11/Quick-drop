abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<Map<String, dynamic>> orders;

  OrderLoaded(this.orders);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderLoaded &&
          runtimeType == other.runtimeType &&
          orders == other.orders;

  @override
  int get hashCode => orders.hashCode;
}

class OrderDetailLoaded extends OrderState {
  final Map<String, dynamic> ordersDetails;
  final List<Map<String, dynamic>> previousOrders;

  OrderDetailLoaded(this.ordersDetails, this.previousOrders);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailLoaded &&
          runtimeType == other.runtimeType &&
          ordersDetails == other.ordersDetails &&
          previousOrders == other.previousOrders;

  @override
  int get hashCode => ordersDetails.hashCode ^ previousOrders.hashCode;
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
