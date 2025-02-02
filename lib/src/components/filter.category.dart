import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_button.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/translate/en.dart';
import 'package:laundromats/src/utils/index.dart';

class FilterCategoryModal extends StatefulWidget {
  const FilterCategoryModal({super.key});

  @override
  State<FilterCategoryModal> createState() => _FilterCategoryModalState();
}

class _FilterCategoryModalState extends State<FilterCategoryModal> {
  final List<String> categories = [
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

  final Set<String> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: vMin(context, 95),
        decoration: BoxDecoration(
          color: kColorWhite,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: vMin(context, 3)),
                  child: Row(
                    children: [
                      Image.asset("assets/images/icons/filter.png"),
                      SizedBox(
                        width: vMin(context, 2),
                      ),
                      Text(
                        filterByCategory.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Onset-Regular',
                          color: kColorSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Image.asset("assets/images/icons/solar-close.png"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(height: vMin(context, 2)),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: categories.map((category) {
                final isSelected = selectedCategories.contains(category);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedCategories.remove(category);
                      } else {
                        selectedCategories.add(category);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? kColorPrimary : kColorWhite,
                      border: Border.all(
                        color: isSelected ? kColorPrimary : kColorInputBorder,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? kColorWhite : kColorSecondary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Onset-Regular',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            Padding(
                padding: EdgeInsets.all(vMin(context, 3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: vMin(context, 28),
                      child: ButtonWidget(
                        btnType: selectedCategories.length == categories.length
                            ? ButtonWidgetType.disSelectAllBtn
                            : ButtonWidgetType.selectAllBtn,
                        borderColor: kColorPrimary,
                        textColor: kColorWhite,
                        fullColor: kColorPrimary,
                        size: false,
                        icon: true,
                        onPressed: () {
                          setState(() {
                            if (selectedCategories.length ==
                                categories.length) {
                              selectedCategories.clear();
                            } else {
                              selectedCategories.addAll(categories);
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: vMin(context, 2),
                    ),
                    SizedBox(
                      width: vMin(context, 28),
                      child: ButtonWidget(
                        btnType: ButtonWidgetType.filterBtn,
                        borderColor: kColorPrimary,
                        textColor: kColorWhite,
                        fullColor: kColorPrimary,
                        size: false,
                        icon: true,
                        onPressed: () {
                          Navigator.of(context).pop(selectedCategories);
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
