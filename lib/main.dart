import 'package:flutter/material.dart';
import "SignUp.dart";
import "package:safecrop/LogIn.dart";

void main() {
  runApp(MaterialApp(
    routes: {
      "/signUp": (context) => SignUp(),
      "/Login": (context) => Login(),
    },
    home: const SafeCropScreen(),
  ));
}

class SafeCropScreen extends StatelessWidget {
  const SafeCropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center all column children
            children: [
              const Spacer(flex: 2),
              // Logo Container with Circle Border
              Center( // Ensure logo is centered
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(35),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
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
                ),
              ),
              const SizedBox(height: 24),
              
              // SafeCrop Text
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
              
              // Status Indicators in a Column
              Column(
                children: [
                  _buildStatusIndicator('Fence monitoring active'),
                  const SizedBox(height: 12),
                  _buildStatusIndicator('Network connected'),
                  const SizedBox(height: 12),
                  _buildStatusIndicator('GPS signal strong'),
                ],
              ),
              
              const Spacer(flex: 3),
              
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
      mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
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