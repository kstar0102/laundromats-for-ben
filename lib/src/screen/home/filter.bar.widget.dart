import 'package:flutter/material.dart';
import 'package:laundromats/src/constants/app_styles.dart';
import 'package:laundromats/src/utils/index.dart';

class FilterBarWidget extends StatelessWidget {
  final Set<String> selectedFilters;
  final Function(Set<String>) onFilterSelected;

  const FilterBarWidget({
    super.key,
    required this.selectedFilters,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: vMin(context, 4),
        vertical: vMin(context, 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterItem(
            context: context,
            title: 'Answered',
            icon: Icons.check_circle_outline,
            filterKey: 'Answered',
          ),
          _buildFilterItem(
            context: context,
            title: 'Unanswered',
            icon: Icons.help_outline,
            filterKey: 'Unanswered',
          ),
          _buildFilterItem(
            context: context,
            title: 'Resolved',
            icon: Icons.done_all,
            filterKey: 'Resolved',
          ),
          _buildFilterItem(
            context: context,
            title: 'Unresolved',
            icon: Icons.cancel_outlined,
            filterKey: 'Unresolved',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String filterKey,
  }) {
    bool isSelected = selectedFilters.contains(filterKey);

    return GestureDetector(
      onTap: () {
        Set<String> newFilters = Set.from(selectedFilters);
        if (isSelected) {
          newFilters.remove(filterKey);
        } else {
          newFilters.add(filterKey);
        }
        onFilterSelected(newFilters);
      },
      child: Container(
        width: vMin(context, 22), // Uniform width
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? kColorPrimary : Colors.grey.shade300),
          color: isSelected
              ? kColorPrimary.withOpacity(0.2)
              : Colors.grey.shade200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? kColorPrimary : Colors.black,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? kColorPrimary : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
