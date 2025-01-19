class MySignatureState {}

class MySignatureInitialState extends MySignatureState {}

class MySignatureLoadingState extends MySignatureState {}

class MySignatureCreateState extends MySignatureState {
  final Map<String, dynamic> signatureData;

  MySignatureCreateState({required this.signatureData});
}

class MySignatureErrorState extends MySignatureState {
  final String error;

  MySignatureErrorState({required this.error});
}
