import 'package:flutter/material.dart';

class FilterPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool alignEnd;

  const FilterPill({
    super.key,
    required this.label,
    required this.onTap,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x22000000),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 41,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const Icon(Icons.chevron_right, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}