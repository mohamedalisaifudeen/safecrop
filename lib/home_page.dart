import 'package:flutter/material.dart';
import 'status_card.dart';
import 'stats_row.dart';
import 'alert_item.dart';
import 'bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SafeCrop',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const StatusCard(),
              const SizedBox(height: 20),
              const StatsRow(),
              const SizedBox(height: 20),
              const Text(
                'Recent Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const AlertItem(
                title: 'Alert',
                time: '15 min ago',
                status: 'Active',
                isActive: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
