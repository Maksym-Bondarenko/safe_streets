import 'package:flutter/material.dart';

import '../../main_pages/profile_page.dart';
import '../contributions/contribution.dart';

/// Custom bar of toggleButtons for filtering purposes
class ToggleButtonBar extends StatefulWidget {
  final List<FilterType> selectedFilters;
  final Function(List<FilterType>) onFilterChanged;
  final List<Contribution> contributions;

  const ToggleButtonBar({
    Key? key,
    required this.selectedFilters,
    required this.onFilterChanged,
    required this.contributions,
  }) : super(key: key);

  @override
  _ToggleButtonBarState createState() => _ToggleButtonBarState();
}

class _ToggleButtonBarState extends State<ToggleButtonBar> {
  List<FilterType> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    selectedFilters = widget.selectedFilters;
  }

  // Function to toggle the selected filters
  void _toggleFilter(FilterType filter) {
    setState(() {
      if (filter == FilterType.all) {
        if (selectedFilters.contains(FilterType.all)) {
          selectedFilters = [];
        } else {
          selectedFilters = [
            FilterType.all,
            FilterType.dangerPoints,
            FilterType.recommendationPoints,
            FilterType.safePoints,
          ];
        }
      } else {
        if (selectedFilters.contains(filter)) {
          selectedFilters.remove(filter);
          selectedFilters.remove(FilterType.all);
        } else {
          selectedFilters.add(filter);
          if (selectedFilters.contains(FilterType.dangerPoints) &&
              selectedFilters.contains(FilterType.recommendationPoints) &&
              selectedFilters.contains(FilterType.safePoints)) {
            selectedFilters.add(FilterType.all);
          }
        }
      }
    });

    widget.onFilterChanged(selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ToggleButton(
            text: 'All',
            isSelected: selectedFilters.contains(FilterType.all),
            onSelected: () => _toggleFilter(FilterType.all),
          ),
          const SizedBox(width: 5),
          ToggleButton(
            text: 'Danger',
            isSelected: selectedFilters.contains(FilterType.dangerPoints),
            onSelected: () => _toggleFilter(FilterType.dangerPoints),
          ),
          const SizedBox(width: 5),
          ToggleButton(
            text: 'Recommendation',
            isSelected:
                selectedFilters.contains(FilterType.recommendationPoints),
            onSelected: () => _toggleFilter(FilterType.recommendationPoints),
          ),
          const SizedBox(width: 5),
          ToggleButton(
            text: 'Safe',
            isSelected: selectedFilters.contains(FilterType.safePoints),
            onSelected: () => _toggleFilter(FilterType.safePoints),
          ),
        ],
      ),
    );
  }
}

/// Custom element of toggleButton
class ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onSelected;

  const ToggleButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Colors.transparent;
    if (isSelected) {
      if (text == 'All') {
        buttonColor = Colors.teal;
      } else if (text == 'Danger') {
        buttonColor = Colors.red;
      } else if (text == 'Recommendation') {
        buttonColor = Colors.yellow;
      } else if (text == 'Safe') {
        buttonColor = Colors.green;
      }
    } else {
      buttonColor = Colors.grey.shade200;
    }

    return GestureDetector(
      onTap: onSelected,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
