import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:istiqama/core/utils/save_manager.dart';
import 'package:istiqama/features/quran/presentation/pages/quran_reader_page.dart';

class SettingsPage extends StatefulWidget {
  final dynamic jsonData;

  const SettingsPage({super.key, this.jsonData});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? lastPage;
  String? lastSuraName;
  dynamic localJsonData;

  loadLastPage() async {
    final page = await SaveManager.getLastPage();
    final suraName = await SaveManager.getLastSuraName();
    setState(() {
      lastPage = page;
      lastSuraName = suraName;
    });
  }

  loadJsonAsset() async {
    if (widget.jsonData != null) {
      localJsonData = widget.jsonData;
      return;
    }
    final String jsonString = await rootBundle.loadString(
      'assets/json/surahs.json',
    );
    localJsonData = jsonDecode(jsonString);
  }

  @override
  void initState() {
    loadLastPage();
    loadJsonAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'العلامات المحفوظة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (lastPage != null &&
                lastSuraName != null &&
                lastSuraName!.isNotEmpty)
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.bookmark,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  title: Text(
                    'سورة $lastSuraName',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    'صفحة $lastPage',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: TextButton.icon(
                    onPressed: () {
                      if (localJsonData != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => QuranViewPage(
                              shouldHighlightText: false,
                              highlightVerse: "",
                              jsonData: localJsonData,
                              pageNumber: lastPage!,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('فتح'),
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'لا توجد علامات محفوظة',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
