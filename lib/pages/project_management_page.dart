import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/project_item.dart';
import '../services/project_store.dart';
import '../widgets/top_bar.dart';
import '../widgets/search_box.dart';
import '../widgets/filter_pill.dart';
import '../widgets/project_card.dart';
import '../widgets/new_project_fab.dart';
import '../widgets/add_project_sheet.dart';
import '../widgets/bottom_nav.dart';

import 'home_page.dart';
import 'profile_page.dart';
import 'notification_page.dart';
import 'file_manager_page.dart';

class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({super.key});

  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  final TextEditingController _searchC = TextEditingController();

  String _statusFilter = 'All Status';
  String _deadlineSort = 'Deadline';

  int _navIndex = 0;

  List<ProjectItem> _all = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _boot();
    _searchC.addListener(() => setState(() {})); // realtime search
  }

  Future<void> _boot() async {
    final items = await ProjectStore.loadOrSeed();
    setState(() {
      _all = items;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      const NotificationPage(),
      const FileManagerPage(),
      const ProfilePage(),
    ];

    // Kalau kamu mau “Project Management” jadi salah satu tab, tinggal geser logic ini.
    // Untuk sekarang: page ini berdiri sendiri, tapi bottom nav tetap ada seperti gambar.
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                TopBar(
                  title: 'Project Management',
                  onBack: () {},
                  onSettings: () {},
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
                          children: [
                            SearchBox(controller: _searchC, hint: 'Search Project'),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: FilterPill(
                                    label: _statusFilter,
                                    onTap: () async {
                                      final v = await _pickOne(context, 'Status', const [
                                        'All Status',
                                        'To Do',
                                        'In Progress',
                                        'Done',
                                      ]);
                                      if (v != null) setState(() => _statusFilter = v);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: FilterPill(
                                    label: _deadlineSort,
                                    alignEnd: true,
                                    onTap: () async {
                                      final v = await _pickOne(context, 'Deadline', const [
                                        'Deadline',
                                        'Nearest',
                                        'Farthest',
                                      ]);
                                      if (v != null) setState(() => _deadlineSort = v);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ..._visibleProjects().map(
                              (p) => Padding(
                                padding: const EdgeInsets.only(bottom: 18),
                                child: ProjectCard(item: p),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),

            // FAB “New Project” card style
            Positioned(
              right: 16,
              bottom: 78,
              child: NewProjectFab(
                onTap: () async {
                  final created = await _openAddProject(context);
                  if (created != null) {
                    setState(() => _all = [created, ..._all]);
                    await ProjectStore.save(_all);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _navIndex,
        onChanged: (i) {
          setState(() => _navIndex = i);

          // navigasi: home & profile sudah ada, notif/file placeholder
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => pages[i]),
          );
        },
      ),
    );
  }

  List<ProjectItem> _visibleProjects() {
    final q = _searchC.text.trim().toLowerCase();

    // filter status
    Iterable<ProjectItem> items = _all.where((p) {
      final matchesSearch = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q);

      final matchesStatus = _statusFilter == 'All Status' ||
          (_statusFilter == 'Done' ? p.percent >= 100 : p.status == _statusFilter);

      return matchesSearch && matchesStatus;
    });

    // sort deadline (sementara string, jadi sorting simpel via string; nanti kalau deadline jadi DateTime baru presisi)
    final list = items.toList();
    if (_deadlineSort == 'Nearest') {
      list.sort((a, b) => a.deadline.compareTo(b.deadline));
    } else if (_deadlineSort == 'Farthest') {
      list.sort((a, b) => b.deadline.compareTo(a.deadline));
    }
    return list;
  }

  Future<String?> _pickOne(BuildContext context, String title, List<String> options) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...options.map(
                (e) => ListTile(
                  title: Text(e),
                  onTap: () => Navigator.pop(context, e),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<ProjectItem?> _openAddProject(BuildContext context) {
    // Popup blur (sesuai request kamu) — desain detailnya nanti bisa kamu kirim
    return showGeneralDialog<ProjectItem>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'add-project',
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, _, _) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: AddProjectSheet(
                  onClose: () => Navigator.pop(context),
                  onSubmit: (p) => Navigator.pop(context, p),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, _, child) {
        final curved = Curves.easeOut.transform(anim.value);
        return Transform.scale(
          scale: 0.96 + (0.04 * curved),
          child: Opacity(opacity: anim.value, child: child),
        );
      },
    );
  }
}