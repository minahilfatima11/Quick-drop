import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:zipline_project/Api%20Services/Bloc/Signature-Bloc/signature_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Signature-Bloc/signature_events.dart';
import 'package:zipline_project/Api%20Services/Bloc/Signature-Bloc/signature_states.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/Home/HomeScreen.dart';
import 'package:zipline_project/core/view/widgets/Profilewdgts/signatureBtn.dart';

class Sendersignaturescreen extends StatefulWidget {
  const Sendersignaturescreen({super.key});

  @override
  State<Sendersignaturescreen> createState() => _SendersignaturescreenState();
}

class _SendersignaturescreenState extends State<Sendersignaturescreen> {
  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: AppColors.appOrange,
    exportBackgroundColor: AppColors.appOrange.withOpacity(0.2),
  );

  Future<void> _saveSignature() async {
    var orderid = await SharedPrefService.getOrderId();
    if (controller.isNotEmpty) {
      // Convert the signature to an image (Uint8List)
      final Uint8List? signatureImage = await controller.toPngBytes();

      if (signatureImage != null) {
        // Save the image as a file
        final Directory tempDir = await getTemporaryDirectory();
        final String tempPath = tempDir.path;
        final File file = File('$tempPath/signature.png');
        var myImage = await file.writeAsBytes(signatureImage);

        // Dispatch the event to the SignatureBloc to handle the API call
        context.read<SignatureBloc>().add(SignatureCreatedEvent(
            orderId: orderid.toString(), imagefile: myImage));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Sender Signature",
          style: TextStyle(color: Colors.black, fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: BlocConsumer<SignatureBloc, MySignatureState>(
          listener: (context, state) {
            if (state is MySignatureCreateState) {
              // Show success message or navigate to another screen
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Signature uploaded successfully!")),
              );
            } else if (state is MySignatureErrorState) {
              log(state.error);
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Error uploading signature: ${state.error}")),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  padding: EdgeInsets.all(0.8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.appOrange, width: 1.5.w)),
                  child: Signature(
                    controller: controller,
                    width: 333.w,
                    height: 400.h,
                    backgroundColor: AppColors.appOrange.withOpacity(0.2),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    },
                    child: Text("Clear")),
                SizedBox(
                  height: 20.h,
                ),
                (state is MySignatureLoadingState)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SignatureBtn(
                        title: "Add Signature",
                        onPressed:
                            _saveSignature, // Call the function to save the signature
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
