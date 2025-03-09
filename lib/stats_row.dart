import 'package:flutter/material.dart';
import 'box_decoration.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(title: "Today's Alerts", value: '3')),
        const SizedBox(width: 16),
        Expanded(child: _StatCard(title: 'Active Sections', value: '8/8')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
