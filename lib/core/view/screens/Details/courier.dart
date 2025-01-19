import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/screens/Details/package_details.dart';
import 'package:zipline_project/core/view/screens/Details/PackageSummaryFourScreen.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';

import 'sender_details_page.dart';
import 'reciever_details_page.dart';

class CourierScreen extends StatefulWidget {
  @override
  _CourierScreenState createState() => _CourierScreenState();
}

class _CourierScreenState extends State<CourierScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Add courier',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50, // Adjust the height as needed
            child: _buildTimeline(),
          ),
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Row(
      children: [
        _buildTimelineTile(0),
        _buildTimelineTile(1),
        _buildTimelineTile(2),
        _buildTimelineTile(3),
      ],
    );
  }

  Widget _buildTimelineTile(int step) {
    return Expanded(
      flex: 1,
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        alignment: TimelineAlign.center,
        isFirst: step == 0,
        isLast: step == 3,
        indicatorStyle: IndicatorStyle(
          color:
              _currentStep >= step ? AppColors.appOrange : Colors.grey.shade300,
          padding: EdgeInsets.all(1),
          indicatorXY: 0.5,
          iconStyle: IconStyle(
            color: Colors.white,
            iconData: _currentStep > step ? Icons.check : Icons.circle,
          ),
        ),
        afterLineStyle: LineStyle(
          color:
              _currentStep > step ? AppColors.appOrange : Colors.grey.shade300,
          thickness: 3,
        ),
        beforeLineStyle: LineStyle(
          color:
              _currentStep > step ? AppColors.appOrange : Colors.grey.shade300,
          thickness: 3,
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return RecieverDetailsPage(onSubmit: _nextStep); // Pass the callback
      case 1:
        return SenderDetailsPage(onSubmit: _nextStep); // Pass the callback
      case 2:
        return PackageDetailsPage(onSubmit: _nextStep); // Pass the callback
      case 3:
        return PackagesummaryPage(onSubmit: _nextStep); // Pass the callback
      default:
        return Container();
    }
  }

  // This method will be called when a form is successfully submitted
  void _nextStep() {
    setState(() {
      if (_currentStep < 3) {
        _currentStep++;
      }
    });
  }
}
