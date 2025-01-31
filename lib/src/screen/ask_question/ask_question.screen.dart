import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({
    super.key,
  });

  @override
  ConsumerState<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final int _currentIndex = 2;
  final bool _isKeyboardVisible = false;
  final _searchValue = TextEditingController();
  final logger = Logger();

  String? uploadedImageUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      return false;
    }
    return false;
  }

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = result.files.first;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File selected: ${file.name}')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected.')),
      );
    }
  }

  void _pickImage(BuildContext context) async {
    // Pick the file
    FilePickerResult? deviceResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'svg', 'webp'],
    );

    if (deviceResult != null) {
      final file = File(deviceResult.files.single.path!);
      final fileName = deviceResult.files.single.name;

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Call the upload function from AuthService
      AuthService authService = AuthService();
      final result = await authService.uploadFile(file, fileName);

      // Close loading dialog
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // Process the result
      if (result['success'] == true) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful!')),
        );
        uploadedImageUrl = result['data']['url'];
        logger.i(uploadedImageUrl);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload: ${result['message']}')),
        );
        logger.e('Upload failed: ${result['message']}');
      }
    } else {
      // User canceled the picker
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isKeyboardVisible == true) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = 800;
      keyboardHeight = 0;
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: kColorWhite,
          resizeToAvoidBottomInset: true,
          body: SizedBox.expand(
              child: SingleChildScrollView(
            child: FocusScope(
              child: Container(
                decoration: const BoxDecoration(color: kColorWhite),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const HeaderWidget(role: true),
                      Padding(
                          padding: EdgeInsets.all(vMin(context, 4)),
                          child: SizedBox(
                            width: vww(context, 100),
                            child: Text(
                              askYourQuestion.toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Onset',
                                color: kColorSecondary,
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with Icon and Text
                            Row(
                              children: [
                                Text(
                                  question.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: typeQuestionHere.toString(),
                                hintStyle: const TextStyle(
                                  color: kColorLightGrey,
                                  fontSize: 14,
                                  fontFamily: 'Onset-Regular',
                                ),
                                contentPadding: const EdgeInsets.all(12.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: kColorInputBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: kColorInputBorder, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: kColorInputBorder),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with Icon and Text
                            Row(
                              children: [
                                Text(
                                  brand.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _searchValue,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  hintText: typeBrandHere.toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableBorder,
                                  focusedBorder: kFocusBorder,
                                  hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorLightGrey),
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  serialNumber.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _searchValue,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  hintText: typeSerialNumberHere.toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableBorder,
                                  focusedBorder: kFocusBorder,
                                  hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorLightGrey),
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  pounds.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _searchValue,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  hintText: typePoundsHere.toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableBorder,
                                  focusedBorder: kFocusBorder,
                                  hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorLightGrey),
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  chooseYear.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _searchValue,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  hintText: chooseYearList.toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableBorder,
                                  focusedBorder: kFocusBorder,
                                  hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorLightGrey),
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  chooseCategory.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _searchValue,
                                keyboardType: TextInputType.name,
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  hintText: chooseCategoryList.toString(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableBorder,
                                  focusedBorder: kFocusBorder,
                                  hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorLightGrey),
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  uploadFile.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            SizedBox(
                                width: vw(context, 50),
                                height: vh(context, 20),
                                child: GestureDetector(
                                  onTap: () => _pickFile(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: kColorInputBorder, width: 1),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.file_present,
                                          size: 40,
                                          color: Colors.grey.withOpacity(0.7),
                                        ),
                                        SizedBox(height: vMin(context, 2)),
                                        Text(
                                          clickUploadFile.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Onset-Regular',
                                            color: kColorInputBorder,
                                          ),
                                        ),
                                        SizedBox(height: vMin(context, 1)),
                                        Text(
                                          pdfSize.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Onset-Regular',
                                            color: kColorInputBorder,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  uploadImage.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // SizedBox(
                            //     width: vw(context, 50),
                            //     height: vh(context, 20),
                            //     child: GestureDetector(
                            //       onTap: () => _pickImage(context),
                            //       child: Container(
                            //         decoration: BoxDecoration(
                            //           border: Border.all(
                            //               color: kColorInputBorder, width: 1),
                            //           borderRadius: BorderRadius.circular(8.0),
                            //         ),
                            //         child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             Icon(
                            //               Icons.image,
                            //               size: 40,
                            //               color: Colors.grey.withOpacity(0.7),
                            //             ),
                            //             SizedBox(height: vMin(context, 2)),
                            //             Text(
                            //               clickUploadImage.toString(),
                            //               style: const TextStyle(
                            //                 fontSize: 16,
                            //                 fontFamily: 'Onset-Regular',
                            //                 color: kColorInputBorder,
                            //               ),
                            //             ),
                            //             SizedBox(height: vMin(context, 1)),
                            //             Text(
                            //               imageSize.toString(),
                            //               style: const TextStyle(
                            //                 fontSize: 14,
                            //                 fontFamily: 'Onset-Regular',
                            //                 color: kColorInputBorder,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     )),
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 20),
                              child: GestureDetector(
                                onTap: () => _pickImage(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kColorInputBorder, width: 1),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: uploadedImageUrl != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            uploadedImageUrl!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              logger.e(
                                                  'Error loading image: $error');
                                              return const Center(
                                                child: Icon(Icons.error,
                                                    color: Colors.red),
                                              );
                                            },
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image,
                                              size: 40,
                                              color:
                                                  Colors.grey.withOpacity(0.7),
                                            ),
                                            SizedBox(height: vMin(context, 2)),
                                            Text(
                                              clickUploadImage.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Onset-Regular',
                                                color: kColorInputBorder,
                                              ),
                                            ),
                                            SizedBox(height: vMin(context, 1)),
                                            Text(
                                              imageSize.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Onset-Regular',
                                                color: kColorInputBorder,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(vMin(context, 4)),
                          child: SizedBox(
                            width: vMin(context, 100),
                            child: ButtonWidget(
                              btnType: ButtonWidgetType.askQuestionsBtn,
                              borderColor: kColorPrimary,
                              textColor: kColorWhite,
                              fullColor: kColorPrimary,
                              size: false,
                              icon: true,
                              onPressed: () {},
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: DottedBorder(
                          color: kColorPrimary,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8.0),
                          strokeWidth: 1,
                          dashPattern: const [2, 2],
                          child: Container(
                            padding: EdgeInsets.all(vMin(context, 2)),
                            width: double.infinity,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: manualAt.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorSecondary,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'manualslib.com',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kColorPrimary,
                                      fontFamily: 'Onset-Regular',
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          )),
          bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex)),
    );
  }
}
