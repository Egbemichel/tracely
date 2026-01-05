import 'package:flutter/material.dart';

import '../app/theme.dart';

class CourseFilters extends StatefulWidget {
  final String selected;
  final Function(String) onFilterChanged;

  const CourseFilters({
    super.key,
    required this.selected,
    required this.onFilterChanged,
  });

  @override
  State<CourseFilters> createState() => _CourseFiltersState();
}

class _CourseFiltersState extends State<CourseFilters> {
  void _select(String filter) {
    widget.onFilterChanged(filter);
  }

  Widget _buildChip(String label) {
    final bool isSelected = widget.selected == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _select(label),
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected
              ? TracelyTheme.secondary500
              : TracelyTheme.neutral300,
          labelStyle: TextStyle(
            color: isSelected ? TracelyTheme.neutral0 : TracelyTheme.primary600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(
              color: isSelected
                  ? TracelyTheme.secondary500
                  : TracelyTheme.neutral300,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip("All"),
          _buildChip("Active"),
          _buildChip("Completed"),
          const SizedBox(width: 8),
          // (your sort/filter buttons unchanged)
        ],
      ),
    );
  }
}
