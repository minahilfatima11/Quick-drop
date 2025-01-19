import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void toastAletMsg(
    {required BuildContext context,
    required String title,
    required String msg}) {
  if (title == "Success") {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      // you can also use RichText widget for title and description parameters
      description: RichText(
        text: TextSpan(
          text: msg,
        ),
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  } else if (title == "Alert") {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.warning,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      // you can also use RichText widget for title and description parameters
      description: RichText(
        text: TextSpan(
          text: msg,
        ),
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(
        Icons.warning,
        color: Colors.white,
      ),
      primaryColor: Colors.orange,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  } else if (title == "Error") {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      // you can also use RichText widget for title and description parameters
      description: RichText(
        text: TextSpan(
          text: msg,
        ),
      ),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      primaryColor: Colors.red,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
}
