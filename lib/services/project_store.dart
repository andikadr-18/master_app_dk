import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_item.dart';

class ProjectStore {
  static const _key = 'projects_v1';

  static Future<List<ProjectItem>> loadOrSeed() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null || raw.trim().isEmpty) {
      final seed = _seed();
      await save(seed);
      return seed;
    }

    try {
      final List list = jsonDecode(raw) as List;
      return list.map((e) => ProjectItem.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (_) {
      final seed = _seed();
      await save(seed);
      return seed;
    }
  }

  static Future<void> save(List<ProjectItem> items) async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await sp.setString(_key, raw);
  }

  static List<ProjectItem> _seed() => const [
        ProjectItem(
          id: 'p1',
          title: 'Renovasi Kantor',
          subtitle: 'Membenarkan Plafon yang rusak',
          percent: 90,
          status: 'In Progress',
          totalTask: 12,
          doneTask: 10,
          remainingTask: 2,
          deadline: '25 Feb 2026',
        ),
        ProjectItem(
          id: 'p2',
          title: 'Working Tools',
          subtitle: 'Membuat Aplikasi Mobile',
          percent: 75,
          status: 'In Progress',
          totalTask: 10,
          doneTask: 7,
          remainingTask: 3,
          deadline: '25 Mar 2026',
        ),
        ProjectItem(
          id: 'p3',
          title: 'Renovasi Rumah',
          subtitle: 'Membenarkan Genteng Rusak',
          percent: 50,
          status: 'To Do',
          totalTask: 5,
          doneTask: 1,
          remainingTask: 4,
          deadline: '25 Juni 2026',
        ),
      ];
}