import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/common/header.widget.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/screen/subscription/partials/manually.screen.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  double screenHeight = 0;
  double keyboardHeight = 0;
  final bool _isKeyboardVisible = false;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const HeaderWidget(role: false, isLogoutBtn: false),
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 4),
                            right: vMin(context, 4),
                            top: vMin(context, 8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getThe.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontFamily: 'Onset',
                                fontWeight: FontWeight.bold,
                                color: kColorSecondary,
                              ),
                            ),
                            Text(
                              premium.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontFamily: 'Onset',
                                fontWeight: FontWeight.bold,
                                color: kColorPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          experience.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'Onset',
                            fontWeight: FontWeight.bold,
                            color: kColorSecondary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: vMin(context, 4),
                            right: vMin(context, 4),
                            top: vMin(context, 4)),
                        child: Center(
                          child: Text(
                            subscriptionDescription.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Onset-Regular',
                              color: kColorSecondary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: vMin(context, 4)),
                      Container(
                        height: vMin(context, 10),
                        width: vMin(context, 80),
                        padding: EdgeInsets.all(vMin(context, 1)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: kColorInputBorder),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTab = 0;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 0
                                        ? kColorPrimary
                                        : kColorWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    billedMonthly.toString(),
                                    style: TextStyle(
                                      color: _selectedTab == 0
                                          ? kColorWhite
                                          : kColorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Onset-Regular',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTab = 1;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _selectedTab == 1
                                        ? kColorPrimary
                                        : kColorWhite,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    billedAnnully.toString(),
                                    style: TextStyle(
                                      color: _selectedTab == 1
                                          ? kColorWhite
                                          : kColorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Onset-Regular',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: vMin(context, 4)),
                      Expanded(
                        child: _selectedTab == 0
                            ? const ManuallyScreen()
                            : const ManuallyScreen(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(vMin(context, 4)),
                        child: SizedBox(
                          width: vMin(context, 100),
                          child: ButtonWidget(
                            btnType: ButtonWidgetType.backBtn,
                            borderColor: kColorPrimary,
                            textColor: kColorWhite,
                            fullColor: kColorPrimary,
                            size: false,
                            icon: true,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
