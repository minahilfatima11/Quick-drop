import 'package:bloc/bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_state.dart';
import 'package:zipline_project/Api%20Services/Repository/order_place_repo.dart';

class OrderPlaceBloc extends Bloc<OrderPlaceEvent, OrderPlaceState> {
  final OrderPlaceRepo orderPlaceRepo;
  OrderPlaceBloc(this.orderPlaceRepo) : super(OrderPlaceInitialState()) {
    on<SenderDetailEvent>((event, emit) async {
      emit(OrderPlaceLoadingState());
      try {
        var sender = await orderPlaceRepo.senderDetails(event.sender);
        emit(SenderDetailsPlacedState(sender: sender));
      } catch (e) {
        emit(OrderPlaceErrorState(error: e.toString()));
      }
    });
    on<ReciverDetailEvent>((event, emit) async {
      emit(OrderPlaceLoadingState());
      try {
        var reciever = await orderPlaceRepo.reciverDetails(event.reciever);
        emit(ReciverDetailsPlacedState(reciver: reciever));
      } catch (e) {
        emit(OrderPlaceErrorState(error: e.toString()));
      }
    });
    on<PackDetailsEvent>((event, emit) async {
      emit(OrderPlaceLoadingState());
      try {
        var package = await orderPlaceRepo.PackageDetails(
            imageFile: event.imageFile,
            orderId: event.orderId,
            itemName: event.itemName,
            itemSize: event.itemSize,
            itemWeight: event.itemSize,
            itemType: event.itemType,
            itemCategory: event.itemCategory,
            deliveryReq: event.deliveryReq,
            charges: event.charges);
        emit(PackageDetailsPlacedState(package: package));
      } catch (e) {
        emit(OrderPlaceErrorState(error: e.toString()));
      }
    });

    on<FetchPackageDetailsEvent>((event, emit) async {
      emit(OrderPlaceLoadingState());
      try {
        var package = await orderPlaceRepo.fetchPackageDetails(event.orderId);
        emit(FetchPackageDetailsState(package: package));
      } catch (e) {
        emit(OrderPlaceErrorState(error: e.toString()));
      }
    });
  }
}
