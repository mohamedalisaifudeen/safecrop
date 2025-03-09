import 'package:flutter/material.dart';

class AlertItem extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final bool isActive;

  const AlertItem({
    required this.title,
    required this.time,
    required this.status,
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.red[50] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child:
                Icon(Icons.warning, color: isActive ? Colors.red : Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
                color: isActive ? Colors.red : Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
