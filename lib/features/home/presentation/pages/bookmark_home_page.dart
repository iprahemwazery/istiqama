import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:istiqama/core/utils/save_manager.dart';
import 'package:istiqama/features/quran/presentation/pages/quran_reader_page.dart';
import 'package:istiqama/features/quran/presentation/pages/surah_list_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic widgejsonData;
  int? lastPage;
  String? lastSuraName;

  loadJsonAsset() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/surahs.json',
    );
    var data = jsonDecode(jsonString);
    if (mounted) {
      setState(() {
        widgejsonData = data;
      });
    }
  }

  loadLastPage() async {
    final page = await SaveManager.getLastPage();
    final suraName = await SaveManager.getLastSuraName();
    if (mounted) {
      setState(() {
        lastPage = page;
        lastSuraName = suraName;
      });
    }
  }

  precacheAssets() async {
    await precacheImage(const AssetImage("assets/images/888-02.png"), context);
    await precacheImage(const AssetImage("assets/images/Basmala.png"), context);
  }

  @override
  void initState() {
    loadJsonAsset();
    loadLastPage();
    precacheAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lastPage != null &&
                lastSuraName != null &&
                lastSuraName!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'آخر قراءة',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'سورة $lastSuraName',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'صفحة $lastPage',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (widgejsonData != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => QuranViewPage(
                                    shouldHighlightText: false,
                                    highlightVerse: "",
                                    jsonData: widgejsonData,
                                    pageNumber: lastPage!,
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('استمرار القراءة'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) =>
                        QuranPage(suraJsonData: widgejsonData),
                  ),
                );
              },
              child: const Text("استعراض السور"),
            ),
          ],
        ),
      ),
    );
  }
}
