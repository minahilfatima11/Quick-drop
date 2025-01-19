import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_bloc.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_event.dart';
import 'package:zipline_project/Api%20Services/Bloc/place_order_bloc/order_place_state.dart';
import 'package:zipline_project/Services/shared_preference_helper.dart';
import 'package:zipline_project/core/utils/Components/alertmsg.dart';
import 'package:zipline_project/core/utils/conts/colors.dart';
import 'package:zipline_project/core/view/widgets/StepperScreenTextField.dart';
import 'package:zipline_project/core/view/widgets/custom_button.dart';
import 'package:zipline_project/core/view/widgets/dropdowntextfieldcourierscreen.dart';

enum Gender { male, female }

class PackageDetailsPage extends StatefulWidget {
  final VoidCallback onSubmit;

  const PackageDetailsPage({super.key, required this.onSubmit});

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  String? selectedItemType;
  String? selectedItemCategory;
  XFile? _imageFile; // Store the picked image file
  String? selecteddevReq;

  // Declare controllers
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemSizeController = TextEditingController();
  final TextEditingController _itemWeightController = TextEditingController();
  final TextEditingController _chargesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers
    _itemNameController.dispose();
    _itemSizeController.dispose();
    _itemWeightController.dispose();
    _chargesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          actions: [
            Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                  child: ListTile(
                    leading: Icon(CupertinoIcons.camera),
                    title: Text('Camera'),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                  child: ListTile(
                    leading: Icon(Icons.photo),
                    title: Text('Gallery'),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: SingleChildScrollView(
        child: BlocConsumer<OrderPlaceBloc, OrderPlaceState>(
          listener: (context, state) {
            if (state is PackageDetailsPlacedState) {
              widget.onSubmit();
            } else if (state is OrderPlaceErrorState) {
              toastAletMsg(context: context, title: "Error", msg: state.error);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Package Details",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Please enter the details below",
                  style: TextStyle(color: AppColors.appBlack.withOpacity(0.5)),
                ),
                SizedBox(height: 5.h),
                StepperScreenTextField(
                  controller: _itemNameController,
                  hint: "Enter item name",
                  image: 'assets/images/itemnav.png',
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(
                      child: StepperScreenTextField(
                        isReadable: true,
                        suffixIcon: IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: AppColors.appBlack.withOpacity(0.3),
                          ),
                        ),
                        controller: TextEditingController(
                            text: _imageFile == null
                                ? 'No image selected'
                                : _imageFile!.name),
                        hint: "Add Image",
                        image: 'assets/images/img.png',
                        imageScale: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                StepperScreenTextField(
                  controller: _itemSizeController,
                  hint: "Size (LxWxH) in ft", // Updated hint for size in feet
                  image: 'assets/images/items.png',
                  imageScale: 1,
                  iconColor: Colors.black,
                ),
                SizedBox(height: 5.h),
                StepperScreenTextField(
                  controller: _itemWeightController,
                  hint: "Weight in lbs", // Updated hint for weight in pounds
                  imageScale: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d+\.?\d{0,2}')), // Allows up to 2 decimal places
                  ],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  image: 'assets/images/itemw.png',
                ),
                SizedBox(height: 5.h),
                DropdownTextFormField(
                  items: [
                    "document",
                    "food",
                    "electronic",
                    "material",
                    "cold",
                    "chain",
                    "other"
                  ],
                  hint: 'Select Item Types',
                  prefixIcon: CupertinoIcons.cube,
                  suffixIcon: Icons.arrow_drop_down,
                  onChanged: (value) {
                    setState(() {
                      selectedItemType = value;
                    });
                  },
                ),
                DropdownTextFormField(
                  items: ["classified", "priority"],
                  hint: 'Select Item Category',
                  prefixIcon: Icons.fire_truck,
                  suffixIcon: Icons.arrow_drop_down,
                  onChanged: (value) {
                    setState(() {
                      selectedItemCategory = value;
                    });
                  },
                ),
                SizedBox(height: 5.h),
                DropdownTextFormField(
                  items: ["yes", "no"],
                  hint: 'Delivery Required',
                  prefixIcon: Icons.fire_truck,
                  suffixIcon: Icons.arrow_drop_down,
                  onChanged: (value) {
                    setState(() {
                      selecteddevReq = value;
                    });
                  },
                ),
                SizedBox(height: 5.h),
                StepperScreenTextField(
                  controller: _chargesController,
                  hint: "Charges",
                  image: 'assets/images/charges.png',
                  imageScale: 1,
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (state is OrderPlaceLoadingState)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustombuttonWidget(
                            onPressed: () async {
                              if (_itemNameController.text.isEmpty ||
                                  _itemSizeController.text.isEmpty ||
                                  _itemWeightController.text.isEmpty ||
                                  selectedItemCategory == null ||
                                  selectedItemType == null ||
                                  _imageFile == null) {
                                var orderid =
                                    await SharedPrefService.getOrderId();
                                String id = orderid.toString();
                                String itemSize =
                                    "${_itemSizeController.text} ft";
                                String itemWeight =
                                    "${_itemWeightController.text} lbs";
                                String charges =
                                    "${_chargesController.text} \$";
                                Map<String, dynamic> data = {
                                  'itemName': _itemNameController.text,
                                  'itemSize': itemSize,
                                  'itemWeight': itemWeight,
                                  'charges': _chargesController.text,
                                  'itemId': selectedItemCategory,
                                  'itemType': selectedItemType,
                                  'devReq': selecteddevReq
                                };
                                log("${data}");

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      title: Text("Incomplete Details"),
                                      content: Text(
                                          "Please fill in all the required fields."),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                var orderid =
                                    await SharedPrefService.getOrderId();
                                String id = orderid.toString();
                                String itemSize =
                                    "${_itemSizeController.text} ft";
                                String itemWeight =
                                    "${_itemWeightController.text} lbs";
                                String charges =
                                    "${_chargesController.text} \$";

                                context.read<OrderPlaceBloc>().add(
                                    PackDetailsEvent(
                                        imageFile: File(_imageFile!.path),
                                        orderId: id,
                                        itemName: _itemNameController.text,
                                        itemSize: itemSize,
                                        itemWeight: itemWeight,
                                        itemType: selectedItemType!,
                                        itemCategory: selectedItemCategory!,
                                        deliveryReq: selecteddevReq!,
                                        charges: charges));
                              }
                            },
                            text: "Submit",
                            buttonHeight: 40.h,
                            buttonWidth: 200.w,
                            buttonBackgroundColor: AppColors.appOrange,
                          ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
