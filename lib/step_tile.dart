import 'package:flutter/material.dart';

class StepTile extends StatelessWidget {
  final String title, time, status;
  final bool isLast;

  const StepTile({
    super.key,
    required this.title,
    required this.time,
    required this.status,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              status == "done" ? Icons.check_circle : Icons.radio_button_unchecked,
              color: status == "done" ? Colors.green : Colors.grey,
            ),
            if (!isLast)
              Container(width: 2, height: 30, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: status == "done" ? Colors.black : Colors.grey,
              ),
            ),
            Text(time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
