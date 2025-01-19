import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zipline_project/Api%20Services/Bloc/Auth-Bloc/auth-bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Orders/orders_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/Signature-Bloc/signature_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/profile-Bloc/profile_bloc.dart';
import 'package:zipline_project/Api%20Services/Repository/auth_repo.dart';
import 'package:zipline_project/Api%20Services/Repository/order_place_repo.dart';
import 'package:zipline_project/Api%20Services/Repository/order_repo.dart';
import 'package:zipline_project/Api%20Services/Repository/profile_repo.dart';
import 'package:zipline_project/Api%20Services/Repository/signature_repo.dart';
import 'package:zipline_project/core/view/screens/Auth/mobiieOtpSendScreen.dart';
import 'package:zipline_project/core/view/screens/Home/HomeScreen.dart';
import 'package:zipline_project/core/view/screens/Auth/LoginScreen.dart';
import 'package:zipline_project/core/view/screens/Auth/RegisterScreen.dart';
import 'package:zipline_project/core/view/screens/Initial%20Screen/SplashScreen.dart';
import 'package:zipline_project/core/view/screens/TabsScreen/TabsScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthRepo authRepo = AuthRepo();
  final ProfileRepo profileRepo = ProfileRepo();
  final OrderRepo orderRepo = OrderRepo();
  final OrderPlaceRepo orderPlaceRepo = OrderPlaceRepo();
  final SignatureRepo signatureRepo = SignatureRepo();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepo),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(profileRepo),
        ),
        BlocProvider(
          create: (context) => OrderBloc(orderRepo),
        ),
        BlocProvider(
          create: (context) => OrderPlaceBloc(orderPlaceRepo),
        ),
        BlocProvider(
          create: (context) => SignatureBloc(signatureRepo),
        ),
      ],
      child: ScreenUtilInit(
          designSize: Size(360, 690),
          builder: (context, child) {
            return MaterialApp(
              theme: ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
              ),
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            );
          }),
    );
  }
}
