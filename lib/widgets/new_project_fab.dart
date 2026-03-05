import 'package:flutter/material.dart';

class NewProjectFab extends StatelessWidget {
  final VoidCallback onTap;
  static const Color NAVY = Color(0xFF101D6E);

  const NewProjectFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 84,
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                radius: 18,
                backgroundColor: NAVY,
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
              SizedBox(height: 6),
              Text(
                'New Project',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}