import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {

  const SupportPage({super.key});

  final String policeNumber = "110";
  final String fireServiceNumber = "112";
  final String medicalServiceNumber = "112";
  final String minorCrime = "0800 6 888 000";
  final String medicalServices = "116 117";
  final String cardCancelation = "116 116";
  final String generalHelpline = "0800 1 11 01 OR 110800 1 11 01 22";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Main Emergency Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.local_police,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Police: $policeNumber',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fire Service: $fireServiceNumber',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.local_hospital,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Medical Service: $medicalServiceNumber',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Minor Emergency Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Minor crime: $minorCrime',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Medical services: $medicalServices',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Card cancelation in case of lost or theft: $cardCancelation',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'General helpline: $generalHelpline',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
