import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../app/theme.dart';

class TracelySearchBar extends StatelessWidget {
  final String text;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  const TracelySearchBar({super.key, required this.text, this.onChanged, this.onSubmitted});



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          icon: const Icon(
            IconsaxPlusLinear.search_normal_1,
            color: TracelyTheme.primary900,
            size: 28,
          ),
          hintText: text,
          hintStyle: const TextStyle(
            fontFamily: "PlusJakartaSans",
            fontSize: 17,
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
