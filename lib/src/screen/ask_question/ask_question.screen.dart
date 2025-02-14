import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/components/bottom_nav_bar.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

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

  final List<String> yearList =
      List.generate(50, (index) => (DateTime.now().year - index).toString());

  final _questionValue = TextEditingController();
  final _brandValue = TextEditingController();
  final _serialNumberValue = TextEditingController();
  final _poundValue = TextEditingController();
  final _yearValue = TextEditingController();
  final _categoryValue = TextEditingController();
  String? uploadedImageUrl;
  String? uploadedFileUrl;

  File? localImageFile;
  final logger = Logger();

  final List<String> categoryList = [
    'Washers',
    'Dryers',
    'Wash and Fold',
    'Start a Laundromat',
    'POS Systems',
    'Card Machines',
    'Heat and Air',
    'Plumbing',
    'Electrical',
    'Wash-Dry-Fold Business Launch',
  ];

  final List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _yearValue.text =
        DateTime.now().year.toString(); // Set default to current year
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

  void _showTagDropdown() async {
    final List<String> availableTags = [
      "New",
      "Barrel",
      "Noise",
      "Washer",
      "Dryer",
      "Steam",
      "Repair",
    ].where((tag) => !_selectedTags.contains(tag)).toList();

    final String? selectedTag = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: availableTags.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(availableTags[index]),
              onTap: () {
                Navigator.pop(context, availableTags[index]);
              },
            );
          },
        );
      },
    );

    if (selectedTag != null) {
      setState(() {
        if (_selectedTags.length < 4) {
          _selectedTags.add(selectedTag);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can select up to 4 tags only.')),
          );
        }
      });
    }
  }

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Limit to PDF files
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      // Show loading dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        // Upload the file using AuthService
        AuthService authService = AuthService();
        final uploadResult =
            await authService.uploadFile(file, fileName, "application/pdf");

        // Close loading dialog
        // ignore: use_build_context_synchronously
        if (mounted) Navigator.pop(context);

        if (uploadResult['success'] == true) {
          // Set the uploaded file URL
          setState(() {
            uploadedFileUrl = uploadResult['data']['url'];
          });

          // Show success message
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully!')),
          );
          logger.i('Uploaded File URL: $uploadedFileUrl');
        } else {
          // Handle failed upload
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Failed to upload file: ${uploadResult['message']}')),
          );
          logger.e('Upload failed: ${uploadResult['message']}');
        }
      } catch (error) {
        // Handle exceptions
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close dialog on error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading file: $error')),
        );
        logger.e('Error: $error');
      }
    } else {
      // User canceled file selection
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
      final result = await authService.uploadFile(file, fileName, "image");

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

        // Save the local file to display before upload
        setState(() {
          localImageFile = file;
          logger.i('Local Image File: ${localImageFile?.path}');
        });

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

  Future<String?> _showYearPicker(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: vh(context, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Year',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Onset-Regular',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: yearList.length,
                  itemBuilder: (context, index) {
                    final isSelected = yearList[index] == _yearValue.text;
                    return ListTile(
                      title: Text(
                        yearList[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Onset-Regular',
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.blue,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context,
                            yearList[index]); // Return the selected year
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _showCategoryPicker(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: vh(context, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Onset-Regular',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    final isSelected =
                        _categoryValue.text == categoryList[index];
                    return ListTile(
                      title: Text(
                        categoryList[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Onset-Regular',
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.blue,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(
                            context,
                            categoryList[
                                index]); // Return the selected category
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitQuestion(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? myId = prefs.getString('userId');

      String selectedTagsAsString = _selectedTags.join(', ');

      // Call the API function and get the response
      AuthService authService = AuthService();
      final result = await authService.createQuestion(
        userId: myId!,
        question: _questionValue.text,
        brand: _brandValue.text,
        serialNumber: _serialNumberValue.text,
        pounds: _poundValue.text,
        year: _yearValue.text,
        category: _categoryValue.text,
        tags: selectedTagsAsString,
        uploadedImageUrl: uploadedImageUrl, // Can be null
        uploadedFileUrl: uploadedFileUrl, // Can be null
      );

      // Close the loading dialog
      // ignore: use_build_context_synchronously
      if (mounted) Navigator.pop(context);

      if (result["success"]) {
        // Success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question created successfully!')),
        );

        // Clear form fields
        setState(() {
          _questionValue.clear();
          _brandValue.clear();
          _serialNumberValue.clear();
          _poundValue.clear();
          _yearValue.text = DateTime.now().year.toString();
          _categoryValue.clear();
          _selectedTags.clear();
          uploadedImageUrl = null; // Reset uploaded image
          uploadedFileUrl = null; // Reset uploaded file
          localImageFile = null;
        });
      } else {
        // Validation error
        if (result.containsKey("missingFields")) {
          String missingFieldsMessage =
              "Missing fields: ${result["missingFields"].join(', ')}";
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(missingFieldsMessage)),
          );
        } else {
          // General error message
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result["message"])),
          );
        }
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      if (mounted) Navigator.pop(context);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $error')),
      );
      logger.i('Unexpected error: $error');
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: kColorWhite,
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(0.0), // Adjust the height as needed
            child: AppBar(
              backgroundColor: kColorWhite,
              elevation: 0, // Removes shadow for a flat UI
              automaticallyImplyLeading:
                  false, // Hides back button if unnecessary
            ),
          ),
          body: SizedBox.expand(
              child: SingleChildScrollView(
            child: FocusScope(
              child: Container(
                decoration: const BoxDecoration(color: kColorWhite),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const HeaderWidget(
                          role: true, isLogoutBtn: false, backIcon: false),
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
                                const Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            TextField(
                              maxLines: 3,
                              controller: _questionValue,
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
                                const Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _brandValue,
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
                                const Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _serialNumberValue,
                                keyboardType: TextInputType.number,
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
                                const Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _poundValue,
                                keyboardType: TextInputType.text,
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
                                const Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _yearValue,
                                keyboardType:
                                    TextInputType.none, // Disable keyboard
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                readOnly:
                                    true, // Make the TextField non-editable
                                onTap: () async {
                                  final selectedYear =
                                      await _showYearPicker(context);
                                  if (selectedYear != null) {
                                    setState(() {
                                      _yearValue.text = selectedYear;
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Choose Year',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableBorder,
                                  focusedBorder: kFocusBorder,
                                  hintStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Onset-Regular',
                                    color: kColorLightGrey,
                                  ),
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
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
                                const Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // Text Field
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 5),
                              child: TextField(
                                controller: _categoryValue,
                                keyboardType:
                                    TextInputType.none, // Disable keyboard
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                readOnly: true, // Prevent direct editing
                                onTap: () async {
                                  final selectedCategory =
                                      await _showCategoryPicker(context);
                                  if (selectedCategory != null) {
                                    setState(() {
                                      _categoryValue.text = selectedCategory;
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Choose Category',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  enabledBorder: kEnableBorder,
                                  focusedBorder: kFocusBorder,
                                  hintStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Onset-Regular',
                                    color: kColorLightGrey,
                                  ),
                                  filled: false,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
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
                            // Header with Text
                            const Row(
                              children: [
                                Text(
                                  "Tags",
                                  style: TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kColorSecondary,
                                  ),
                                ),
                                Text(
                                  " *",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            // GestureDetector Container for Tag Selection
                            GestureDetector(
                              onTap:
                                  _showTagDropdown, // Function to open dropdown for tag selection
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical:
                                        0), // Adjust padding for text alignment
                                width: vw(context,
                                    50), // Same width as the text field
                                height: vh(context,
                                    6.5), // Adjust height for better layout
                                decoration: BoxDecoration(
                                  border: Border.all(color: kColorInputBorder),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Vertically center content
                                  children: [
                                    if (_selectedTags.isEmpty)
                                      const Expanded(
                                        child: Text(
                                          "Click to select tags...", // Placeholder text
                                          style: TextStyle(
                                            color:
                                                kColorLightGrey, // Light grey color for placeholder
                                            fontSize: 15, // Adjust font size
                                          ),
                                        ),
                                      ),
                                    if (_selectedTags.isNotEmpty)
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis
                                              .vertical, // Allow vertical scrolling if needed
                                          child: Wrap(
                                            spacing:
                                                3.0, // Adjust horizontal spacing between tags
                                            runSpacing:
                                                2.0, // Adjust vertical spacing between rows
                                            children: [
                                              // Render selected tags as Chips
                                              for (String tag in _selectedTags)
                                                Chip(
                                                  label: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: '# ',
                                                          style: TextStyle(
                                                            fontSize:
                                                                13, // Adjust font size
                                                            color: Colors
                                                                .green, // Green color for #
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: tag,
                                                          style:
                                                              const TextStyle(
                                                            fontSize:
                                                                12, // Adjust font size
                                                            color: Colors
                                                                .black, // Black color for the text
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Rounded corners
                                                    side: const BorderSide(
                                                        color: Colors
                                                            .green), // Green border
                                                  ),
                                                  deleteIcon: const Icon(
                                                    Icons.close,
                                                    size:
                                                        15, // Adjust delete icon size
                                                    color: Colors
                                                        .green, // Green color for delete icon
                                                  ),
                                                  onDeleted: () {
                                                    setState(() {
                                                      _selectedTags.remove(
                                                          tag); // Remove tag on delete
                                                    });
                                                  },
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap, // Reduce tap area
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
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
                                onTap: () => _pickFile(
                                    context), // Trigger the file picker
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kColorInputBorder, width: 1),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: uploadedFileUrl != null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_present,
                                              size: 40,
                                              // ignore: deprecated_member_use
                                              color: Colors.green.withOpacity(
                                                  0.7), // Success color
                                            ),
                                            SizedBox(height: vMin(context, 2)),
                                            const Text(
                                              "File Uploaded Successfully!",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Onset-Regular',
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(height: vMin(context, 1)),
                                            Text(
                                              uploadedFileUrl!
                                                  .split('/')
                                                  .last, // Extract file name from URL
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Onset-Regular',
                                                color: kColorInputBorder,
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // Truncate long file names
                                              maxLines: 1,
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_present,
                                              size: 40,
                                              color:
                                                  // ignore: deprecated_member_use
                                                  Colors.grey.withOpacity(0.7),
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
                              ),
                            )
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
                            SizedBox(
                              width: vw(context, 50),
                              height: vh(context, 20),
                              child: GestureDetector(
                                onTap: () => _pickImage(
                                    context), // Call the pick image function
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kColorInputBorder, width: 1),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: localImageFile !=
                                          null // Display local image if available
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.file(
                                            localImageFile!,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : uploadedImageUrl !=
                                              null // Display uploaded image URL if available
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
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
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
                                              // Placeholder UI for when no image is selected
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image,
                                                  size: 40,
                                                  color: Colors.grey
                                                      // ignore: deprecated_member_use
                                                      .withOpacity(0.7),
                                                ),
                                                SizedBox(
                                                    height: vMin(context, 2)),
                                                Text(
                                                  clickUploadImage.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'Onset-Regular',
                                                    color: kColorInputBorder,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: vMin(context, 1)),
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
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(vMin(context, 4)),
                          child: SizedBox(
                            width: vMin(context, 100),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    kColorPrimary, // Green background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7,
                                    horizontal: 20), // Adjust padding
                              ),
                              onPressed: () {
                                _submitQuestion(context);
                              },
                              child: const Text(
                                "Ask Question",
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 15,
                                  fontFamily: 'Onset-Regular',
                                ),
                              ),
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
                                  TextSpan(
                                    text: 'manualslib.com',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Onset-Regular',
                                      color: kColorPrimary,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final Uri url =
                                            Uri.parse('https://manualslib.com');

                                        // Try launching the URL
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Could not open the URL.')),
                                          );
                                        }
                                      },
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
