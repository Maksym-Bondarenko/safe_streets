import 'package:flutter/material.dart';

const String _policeNumber = "110";
const String _fireServiceNumber = "112";
const String _medicalServiceNumber = "112";
const String _minorCrime = "0800 6 888 000";
const String _medicalServices = "116 117";
const String _cardCancellation = "116 116";
const String _generalHelpline = "080011101 OR 1108001110122";

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
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
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.blue,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Text(
                    "Main Emergency Information".toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Police: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: _policeNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Fire Service: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: _fireServiceNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Medical Service: ',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: _medicalServiceNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.blue,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Minor Emergency Information".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Minor crime: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: _minorCrime,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Medical services: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: _medicalServices,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Card cancellation in case of lost or theft: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: _cardCancellation,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'General helpline: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: _generalHelpline,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
