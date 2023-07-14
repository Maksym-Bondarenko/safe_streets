import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../ui/bottom_menu/bottom_navigation_bar.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPage();
}

class _SupportPage extends State<SupportPage> {
  List<CountryData> countries = [];
  CountryData? selectedCountry;

  @override
  void initState() {
    super.initState();
    loadSupportData();
  }

  void loadSupportData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('lib/assets/data/support_data.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    setState(() {
      countries = List<Map<String, dynamic>>.from(jsonData['countries'])
          .map((country) => CountryData.fromJson(country))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: DropdownButton<CountryData>(
                value: selectedCountry,
                onChanged: (CountryData? newValue) {
                  setState(() {
                    selectedCountry = newValue;
                  });
                },
                items: countries
                    .map<DropdownMenuItem<CountryData>>((CountryData country) {
                  return DropdownMenuItem<CountryData>(
                    value: country,
                    child: Text(
                        country.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0
                        )
                    ),
                  );
                }).toList(),
                hint: const Text('Select a country',
                    style:
                        TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0
                        )
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                dropdownColor: Colors.grey.shade50,
                style: const TextStyle(color: Colors.black),
                underline: Container(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blue,
                ),
                iconSize: 30,
                focusColor: Colors.blue,

              ),
            ),
            const Divider(
              color: Colors.blue,
              thickness: 2,
              height: 40,
              indent: 20,
              endIndent: 20,
            ),
            if (selectedCountry != null)
              Card(
                elevation: 12,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                    style: BorderStyle.solid,
                  ),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Major Phone Numbers'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Police: ${selectedCountry!.majorPhoneNumbers[0]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Fire Services: ${selectedCountry!.majorPhoneNumbers[1]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Medical Services: ${selectedCountry!.majorPhoneNumbers[2]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (selectedCountry != null)
              Card(
                elevation: 12,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                    style: BorderStyle.solid,
                  ),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'General Help Line'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedCountry!.generalHelpLine,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (selectedCountry == null)
              Column(
                children: [
                  _buildSkeletonCard(context),
                  const SizedBox(height: 20),
                  _buildSkeletonCard(context),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}

// create a skeleton-card (when no country selected)
Widget _buildSkeletonCard(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final cardWidth = screenWidth * 0.6;

  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.blue,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: cardWidth,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: cardWidth,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: cardWidth,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}

class CountryData {
  final String id;
  final String name;
  final List<String> majorPhoneNumbers;
  final String generalHelpLine;

  CountryData({
    required this.id,
    required this.name,
    required this.majorPhoneNumbers,
    required this.generalHelpLine,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: json['id'],
      name: json['name'],
      majorPhoneNumbers: List<String>.from(json['majorPhoneNumbers']),
      generalHelpLine: json['generalHelpLine'],
    );
  }
}
