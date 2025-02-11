import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/utils/shared_preferences_util.dart';

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
  String? _imageUrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString("userName") ?? "";
      _emailController.text = prefs.getString("userEmail") ?? "";
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
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  /// **Update Profile Information**
  Future<void> _updateProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await SharedPreferencesUtil.saveUserDetails(
      userId: prefs.getString("userId") ?? "",
      userName: _nameController.text.trim(),
      userEmail: _emailController.text.trim(),
      userExpertIn: prefs.getString("userExpertIn") ?? "",
      userBusinessTime: prefs.getString("userBusinessTime") ?? "",
      userLaundromatsCount: prefs.getString("userLaundromatsCount") ?? "",
    );

    if (mounted) {
      Navigator.pop(context, true); // Return to previous screen
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const HeaderWidget(role: false, isLogoutBtn: false),
              SizedBox(
                height: vh(context, 2),
              ),

              /// **Profile Picture Upload**
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (_imageUrl != null && _imageUrl!.isNotEmpty)
                              ? NetworkImage(_imageUrl!) as ImageProvider
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: kColorPrimary,
                        radius: 20,
                        child: IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
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

              /// **Username Field**

              SizedBox(height: vh(context, 4)),

              /// **Save Changes Button**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: vMin(context, 30),
                    child: ButtonWidget(
                      btnType: ButtonWidgetType.backBtn,
                      borderColor: kColorPrimary,
                      textColor: kColorWhite,
                      fullColor: kColorPrimary,
                      size: false,
                      icon: true,
                      onPressed: onBackClicked,
                    ),
                  ),
                  SizedBox(
                    width: vMin(context, 30),
                    child: ButtonWidget(
                      btnType: ButtonWidgetType.nextBtn,
                      borderColor: kColorPrimary,
                      textColor: kColorWhite,
                      fullColor: kColorPrimary,
                      size: false,
                      icon: true,
                      onPressed: _updateProfile,
                    ),
                  ),
                ],
              ),
              SizedBox(height: vh(context, 4)),
            ],
          ),
        ),
      ),
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
