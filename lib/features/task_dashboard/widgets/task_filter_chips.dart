import 'package:flutter/material.dart';

class TaskFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Map<String, int> statusCounts;
  final Function(String) onFilterSelected;

  const TaskFilterChips({
    super.key,
    required this.selectedFilter,
    required this.statusCounts,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {"name": "New", "value": "New"},
      {"name": "Progress", "value": "Progress"},
      {"name": "Completed", "value": "Completed"},
      {"name": "Cancelled", "value": "Cancelled"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: filters.map((filter) {
          final String value = filter['value']!;
          final String name = filter['name']!;
          final bool isSelected = selectedFilter == value;
          final int count = statusCounts[value] ?? 0;
          final String chipText = count > 0 ? "$name ($count)" : name;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(
                chipText,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFF2D6A4F),
              backgroundColor: const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.transparent),
              ),
              onSelected: (selected) {
                if (selected) onFilterSelected(value);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}