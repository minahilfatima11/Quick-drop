class OrderPlaceState {}

class OrderPlaceInitialState extends OrderPlaceState {}

class OrderPlaceLoadingState extends OrderPlaceState {}

class SenderDetailsPlacedState extends OrderPlaceState {
  final Map<String, dynamic> sender;

  SenderDetailsPlacedState({required this.sender});
}

class ReciverDetailsPlacedState extends OrderPlaceState {
  final Map<String, dynamic> reciver;

  ReciverDetailsPlacedState({required this.reciver});
}

class PackageDetailsPlacedState extends OrderPlaceState {
  final Map<String, dynamic> package;

  PackageDetailsPlacedState({required this.package});
}

class FetchPackageDetailsState extends OrderPlaceState {
  final Map<String, dynamic> package;

  FetchPackageDetailsState({required this.package});
}

class OrderPlaceErrorState extends OrderPlaceState {
  final String error;

  OrderPlaceErrorState({required this.error});
}
