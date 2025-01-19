import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Signature-Bloc/signature_events.dart';
import 'package:zipline_project/Api%20Services/Bloc/Signature-Bloc/signature_states.dart';
import 'package:zipline_project/Api%20Services/Repository/signature_repo.dart';

class SignatureBloc extends Bloc<SignatureEvents, MySignatureState> {
  final SignatureRepo signatureRepo;

  SignatureBloc(this.signatureRepo) : super(MySignatureInitialState()) {
    on<SignatureCreatedEvent>((event, emit) async {
      emit(MySignatureLoadingState());
      try {
        final signatureData =
            await signatureRepo.senderSignature(event.orderId, event.imagefile);
        emit(MySignatureCreateState(signatureData: signatureData));
      } catch (e) {
        emit(MySignatureErrorState(error: "Failed to fetch orders: $e"));
      }
    });
    on<ReciverSignatureCreatedEvent>((event, emit) async {
      emit(MySignatureLoadingState());
      try {
        final signatureData =
            await signatureRepo.senderSignature(event.orderId, event.imagefile);
        emit(MySignatureCreateState(signatureData: signatureData));
      } catch (e) {
        emit(MySignatureErrorState(error: "Failed to fetch orders: $e"));
      }
    });
  }
}
