import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class HeaderWidget extends ConsumerStatefulWidget {
  const HeaderWidget({super.key, required this.role});
  final bool? role;

  @override
  ConsumerState<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends ConsumerState<HeaderWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: vMin(context, 3),
                right: vMin(context, 3),
                top: vMin(context, 10),
                bottom: vMin(context, 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/icons/icon.png',
                ),
                SizedBox(
                  width: vMin(context, 1),
                ),
                Text(
                  appName.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Onset-Regular',
                      fontWeight: FontWeight.bold,
                      color: kColorPrimary),
                ),
              ],
            ),
          ),
          SizedBox(
            height: vMin(context, 2),
          ),
          widget.role == false
              ? const Divider(
                  color: kColorPrimary,
                  thickness: 1,
                )
              : Container(
                  width: vMin(context, 100),
                  height: vMin(context, 10),
                  decoration: const BoxDecoration(
                    color: kColorPrimary,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/icons/crown.png",
                      ),
                      SizedBox(width: vMin(context, 2)),
                      Text(
                        getPremium.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Onset-Regular',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
        ]);
  }
}
