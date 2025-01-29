import 'package:flutter/material.dart';
import 'package:laundromats/src/utils/index.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    this.totalSteps = 2,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index <= currentStep ? activeColor : Colors.transparent,
                border: Border.all(
                  color: index <= currentStep ? activeColor : inactiveColor,
                  width: 1,
                ),
              ),
              child: index <= currentStep
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (index < totalSteps - 1)
              SizedBox(
                width: vMin(context, 70),
                child: Divider(
                  color: index < currentStep ? activeColor : inactiveColor,
                  thickness: 2,
                ),
              ),
          ],
        );
      }),
    );
  }
}
