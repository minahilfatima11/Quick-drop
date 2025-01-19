import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_state.dart';

import '../../Repository/order_repo.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepo orderRepo;

  OrderBloc(this.orderRepo) : super(OrderInitial()) {
    on<FetchAllOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await orderRepo.getAllOrder(event.userId);
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError("Failed to fetch orders: $e"));
      }
    });

    on<FetchCompletedOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await orderRepo.getCompletedOrder(event.userId);
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError("Failed to fetch completed orders: $e"));
      }
    });

    on<FetchPickupPendingLoadedOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await orderRepo.getPickUpOrder(event.userId);
        log("${orders}");
        emit(OrderLoaded(orders));
      } catch (e) {
        log("${e.toString()}");
        emit(OrderError("Failed to fetch pickup orders: $e"));
      }
    });

    // on<FetchPickupLoadedOrdersEvent>((event, emit) async {
    //   emit(OrderLoading());
    //   try {
    //     final orders = await orderRepo.Pickup(event.userId);
    //     emit(OrderLoaded(orders));
    //   } catch (e) {
    //     emit(OrderError("Failed to fetch pickup-loaded orders: $e"));
    //   }
    // });

    on<FetchDeliveredOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await orderRepo.getDeliveredOrder(event.userId);
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError("Failed to fetch delivered orders: $e"));
      }
    });

    on<FetchDeliveryPendingOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await orderRepo.getDeliveryPendingOrder(event.userId);
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError("Failed to fetch delivery-pending orders: $e"));
      }
    });
    on<FetchRecentOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await orderRepo.recentOrder(event.userId);
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError("Failed to fetch delivery-pending orders: $e"));
      }
    });

    on<FetchOrderDetailsEvent>((event, emit) async {
      if (state is OrderLoaded) {
        var currentState = state as OrderLoaded;
        emit(OrderLoading());
        try {
          final detail = await orderRepo.orderDetails(event.orderNo);
          emit(OrderDetailLoaded(detail, currentState.orders));
        } catch (e) {
          emit(OrderError("Failed to fetch orders: $e"));
        }
      } else {
        emit(OrderLoading());
        try {
          final detail = await orderRepo.orderDetails(event.orderNo);
          emit(OrderDetailLoaded(detail, []));
        } catch (e) {
          emit(OrderError("Failed to fetch orders: $e"));
        }
      }
    });
  }
}
