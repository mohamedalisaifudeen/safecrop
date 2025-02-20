import 'package:flutter/material.dart';
import "SignUp.dart";
import "package:safecrop/LogIn.dart";

void main() {
  runApp(MaterialApp(
    routes: {
      "/signUp": (context) => SignUp(),
      "/Login": (context) => Login(),
    },
    home: const SafecropScreen(), // Changed to new loading screen
  ));
}

class SafecropScreen extends StatelessWidget {
  const SafecropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container with Circle Border
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: GridView.count(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(25),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: List.generate(
                      4,
                      (index) => Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D3B55),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Safecrop Text
              const Text(
                'SafeCrop',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3B55),
                ),
              ),
              const SizedBox(height: 8),
              
              // Initializing System Text
              Text(
                'Initializing System...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              
              // Connecting to sensors Text
              Text(
                'Connecting to sensors...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),
              
              // Status Indicators
              _buildStatusIndicator('Fence monitoring active'),
              const SizedBox(height: 8),
              _buildStatusIndicator('Network connected'),
              const SizedBox(height: 8),
              _buildStatusIndicator('GPS signal strong'),
              
              const Spacer(),
              
              // Bottom Text
              const Text(
                'Wildlife Protection Systems',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2D3B55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2D3B55),
          ),
        ),
      ],
    );
  }
}
