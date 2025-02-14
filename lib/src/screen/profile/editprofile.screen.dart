import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/screen/profile/profile.screen.dart';
import 'package:laundromats/src/services/authservice.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laundromats/src/constants/app_styles.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userRoleContoller = TextEditingController();
  final TextEditingController _userExpertInContoller = TextEditingController();
  final TextEditingController _userBusinessYearContoller =
      TextEditingController();
  final TextEditingController _userLaundromatsCountContoller =
      TextEditingController();
  final Logger logger = Logger();

  File? _profileImage;
  String? uploadedImageUrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _nameController.text = GlobalVariable.userName ?? "";
      _emailController.text = GlobalVariable.userEmail ?? "";
      _userRoleContoller.text = GlobalVariable.userRole ?? "";
      _userExpertInContoller.text = GlobalVariable.userExpertIn ?? "";
      _userBusinessYearContoller.text = GlobalVariable.userbusinessTime ?? "";
      _userLaundromatsCountContoller.text =
          GlobalVariable.userLaundromatsCount ?? "";
    });
  }

  /// **Image Picker (Camera & Gallery)**
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImage(imageFile);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    showDialog(
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
    final result =
        await authService.uploadFile(imageFile, imageFile.path, "image");

    // Close loading dialog
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    // Process the result
    if (result['success'] == true) {
      uploadedImageUrl = result['data']['url'];

      setState(() {
        _profileImage = imageFile;
        logger.i('Local Image File: ${_profileImage?.path}');
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changed successful!')),
      );

      logger.i(uploadedImageUrl);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload: ${result['message']}')),
      );
      logger.e('Upload failed: ${result['message']}');
    }
  }

  /// **Update Profile Information**
  Future<void> _updateProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
      return;
    }
    // Retrieve userId from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    if (userId == null) {
      _showErrorDialog("User ID not found. Please log in again.");
      return;
    }

    // Prepare request data
    Map<String, dynamic> requestData = {
      "userId": userId,
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "role": _userRoleContoller.text.trim().isNotEmpty
          ? _userRoleContoller.text.trim()
          : "", // Handle nullable role
      "role_expertIn": _userExpertInContoller.text.trim().isNotEmpty
          ? _userExpertInContoller.text.trim()
          : "",
      "role_businessTime": _userBusinessYearContoller.text.trim().isNotEmpty
          ? _userBusinessYearContoller.text.trim()
          : "",
      "role_laundromatsCount":
          _userLaundromatsCountContoller.text.trim().isNotEmpty
              ? _userLaundromatsCountContoller.text.trim()
              : "",
      "user_image": uploadedImageUrl ??
          GlobalVariable.userImageUrl, // Use stored uploaded image URL
    };

    try {
      AuthService authService = AuthService();
      final result = await authService.updateUserProfile(requestData);

      // Close loading dialog
      // ignore: use_build_context_synchronously
      final navigator = Navigator.of(context);

      navigator.push(
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );

      if (result['success']) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      } else {
        _showErrorDialog(result['message'] ?? "Failed to update profile.");
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      _showErrorDialog("An error occurred: $e");
    }
  }

  void onBackClicked() {
    Navigator.pop(context);
  }

  /// **Show Error Dialog**
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  bool allowRevert = true;

  Future<bool> _onWillPop() async {
    if (!allowRevert) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          body: Container(
            color: kColorWhite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const HeaderWidget(
                      role: false, isLogoutBtn: false, backIcon: true),
                  SizedBox(
                    height: vh(context, 2),
                  ),

                  /// **Profile Picture Upload**
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors
                              .grey[300], // Light grey background when loading
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (GlobalVariable.userImageUrl != null &&
                                      GlobalVariable.userImageUrl!.isNotEmpty)
                                  ? NetworkImage(GlobalVariable.userImageUrl!)
                                      as ImageProvider
                                  : null,
                          child: (_profileImage == null &&
                                  (GlobalVariable.userImageUrl == null ||
                                      GlobalVariable.userImageUrl!.isEmpty))
                              ? const Icon(
                                  Icons.person,
                                  color: kColorPrimary,
                                  size: 50,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: kColorPrimary,
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                              onPressed: () {
                                _showImageSourceDialog();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: vh(context, 3)),

                  Padding(
                    padding: EdgeInsets.only(
                        top: vh(context, 2),
                        left: vw(context, 3),
                        right: vw(context, 3)),
                    child: Column(
                      children: [
                        _buildInputField(
                            "Full Name", _nameController, TextInputType.text),

                        /// **Email Field**
                        _buildInputField("Email Address", _emailController,
                            TextInputType.emailAddress),

                        /// **Password Field (Optional)**
                        _buildInputField(
                          "User Role",
                          _userRoleContoller,
                          TextInputType.text,
                        ),

                        GlobalVariable.userRole == "Owner"
                            ? const SizedBox
                                .shrink() // Return an empty widget if the condition is true
                            : _buildInputField(
                                "Expert In",
                                _userExpertInContoller,
                                TextInputType.text,
                              ),

                        _buildInputField(
                          "Business Year",
                          _userBusinessYearContoller,
                          TextInputType.text,
                        ),

                        GlobalVariable.userRole == "Machanic"
                            ? const SizedBox
                                .shrink() // Return an empty widget if the condition is true
                            : _buildInputField(
                                "Laundromats Counts",
                                _userLaundromatsCountContoller,
                                TextInputType.text,
                              ),
                      ],
                    ),
                  ),

                  SizedBox(height: vh(context, 3)),

                  /// **Save Changes Button**
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: vMin(context, 30),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                kColorPrimary, // Green background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 20), // Adjust padding
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 15,
                              fontFamily: 'Onset-Regular',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: vMin(context, 30),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                kColorPrimary, // Green background color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 20), // Adjust padding
                          ),
                          onPressed: _updateProfile,
                          child: const Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 15,
                              fontFamily: 'Onset-Regular',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: vh(context, 5)),
                ],
              ),
            ),
          )),
    );
  }

  /// **Input Field Widget**
  Widget _buildInputField(
      String label, TextEditingController controller, TextInputType type,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: kColorBlack),
        ),
        SizedBox(height: vh(context, 1)),
        SizedBox(
          height: 40, // Set desired height
          child: TextField(
            controller: controller,
            keyboardType: type,
            obscureText: isPassword,
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: kEnableSearchBorder,
              focusedBorder: kFocusSearchBorder,
              filled: false,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
            ),
          ),
        ),
        SizedBox(height: vh(context, 2)),
      ],
    );
  }

  /// **Show Dialog for Image Source Selection**
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take a photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
