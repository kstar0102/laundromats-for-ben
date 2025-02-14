import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/common/progress.widget.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/login_step/mechanic.screen.dart';
import 'package:laundromats/src/screen/login_step/other.screen.dart';
import 'package:laundromats/src/screen/login_step/owner.screen.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/global_variable.dart';
import 'package:laundromats/src/utils/index.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  double screenHeight = 0;
  double keyboardHeight = 0;
  int currentStep = 0;
  final bool _isKeyboardVisible = false;
  int? selectedRole = 0;

  final List<Map<String, dynamic>> roles = [
    {"icon": 'assets/images/icons/setting.png', "label": mechanic.toString()},
    {"icon": 'assets/images/icons/owner.png', "label": owner.toString()},
    {"icon": 'assets/images/icons/smile-circle.png', "label": other.toString()},
  ];

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

  Future<void> _onClickCategory() async {
    if (selectedRole == 0) {
      GlobalVariable.userRole = "Mechanic";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MechanicScreen(),
        ),
      );
    } else if (selectedRole == 1) {
      GlobalVariable.userRole = "Owner";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OwnerScreen(),
        ),
      );
    } else if (selectedRole == 2) {
      GlobalVariable.userRole = "Other";
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OtherScreen(),
        ),
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
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
                height: vhh(context, 100),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const HeaderWidget(
                        role: true,
                        isLogoutBtn: false,
                        backIcon: true,
                      ),
                      SizedBox(
                        height: vMin(context, 10),
                      ),
                      Text(
                        letGetStarted.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'Onset',
                            fontWeight: FontWeight.bold,
                            color: kColorSecondary),
                      ),
                      SizedBox(
                        height: vMin(context, 1),
                      ),
                      Text(
                        letGetStartedDescription.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Onset-Regular',
                            color: kColorSecondary),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 5)),
                        child: ProgressIndicatorWidget(
                          currentStep: currentStep,
                          activeColor: kColorPrimary,
                          // ignore: deprecated_member_use
                          inactiveColor: kColorSecondary.withOpacity(0.5),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(vMin(context, 5)),
                          child: Container(
                            padding: EdgeInsets.all(vMin(context, 5)),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: kColorPrimary, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  roleName.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Onset-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: vMin(context, 5)),
                                ...List.generate(roles.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedRole = index;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: vMin(context, 2)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: vMin(context, 2),
                                          horizontal: vMin(context, 2)),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedRole == index
                                              ? kColorPrimary
                                              : kColorPrimary,
                                          width: selectedRole == index ? 1 : 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: selectedRole == index
                                            ? Colors.green.shade50
                                            : Colors.transparent,
                                      ),
                                      child: Row(
                                        children: [
                                          roles[index]["icon"] is String
                                              ? Image.asset(
                                                  roles[index]["icon"],
                                                  height: 24,
                                                  width: 24,
                                                )
                                              : Icon(
                                                  roles[index]["icon"],
                                                  color: kColorPrimary,
                                                  size: 24,
                                                ),
                                          SizedBox(width: vMin(context, 2)),
                                          Text(
                                            roles[index]["label"],
                                            style: const TextStyle(
                                              color: kColorSecondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(height: vMin(context, 5)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Spacer(),
                                    SizedBox(
                                      width: vMin(context, 20),
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
                                          _onClickCategory();
                                        },
                                        child: const Text(
                                          "Next",
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontSize: 15,
                                            fontFamily: 'Onset-Regular',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          )),
        ));
  }
}
