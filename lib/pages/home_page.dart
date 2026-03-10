import 'package:flutter/material.dart';

import 'feature_page.dart';
import 'file_manager_page.dart';
import '../projects/project_management_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color navy = Color(0xFF101D6E);
  static const Color bg = Color(0xFFF2F9FF);
  static const Color card = Color(0xFFFAFEFF);
  static const Color soft = Color(0xFFF4F5FF);
  static const Color border = Color(0xFFDCECFF);
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);

  int _bottomNavIndex = 0;
  bool _showSettings = false;

  bool _darkMode = false;
  bool _pinEnabled = false;
  String _language = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(),
                        const SizedBox(height: 18),
                        _buildQuickActionRow(),
                        const SizedBox(height: 22),
                        _buildMenuGrid(),
                        const SizedBox(height: 16),
                        _buildRecentActivities(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (_showSettings) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showSettings = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                top: 70,
                right: 18,
                child: _buildSettingsPopup(),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: navy,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://placehold.co/100x100'),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hanyakra Narendra',
                  style: TextStyle(
                    color: text,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Supervisor',
                  style: TextStyle(
                    color: muted,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => Container(
          width: 78,
          height: 54,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final items = [
      _MenuItem(
        Icons.insert_drive_file_outlined,
        'File Manager',
        (_) => const FileManagerPage(),
      ),
      _MenuItem(
        Icons.assignment_outlined,
        'Project Management',
        (_) => const ProjectManagementPage(),
      ),
      _MenuItem(
        Icons.inventory_2_outlined,
        'Inventory',
        (_) => const FeaturePage(title: 'Inventory'),
      ),
      _MenuItem(
        Icons.calendar_today_outlined,
        'Notes',
        (_) => const FeaturePage(title: 'Notes'),
      ),
      _MenuItem(
        Icons.payments_outlined,
        'Finance',
        (_) => const FeaturePage(title: 'Finance'),
      ),
      _MenuItem(
        Icons.grid_view_rounded,
        'Service All',
        (_) => const FeaturePage(title: 'Service All'),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.16,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildMenuTile(item);
      },
    );
  }

  Widget _buildMenuTile(_MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: item.pageBuilder),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 30, color: Colors.black87),
              const SizedBox(height: 10),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activities',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _activityTile(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            title: 'Safety inspection Completed',
          ),
          _activityTile(
            icon: Icons.inventory_2,
            iconColor: Colors.lime,
            title: 'Inventory Update',
          ),
          _activityTile(
            icon: Icons.assignment,
            iconColor: Colors.brown,
            title: 'New Task Assigned',
          ),
        ],
      ),
    );
  }

  Widget _activityTile({
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black87,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPopup() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 250,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Pengaturan',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, size: 18, color: Colors.black54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _settingsSection(
              title: 'Tampilan',
              children: [
                _settingSwitchTile(
                  icon: Icons.nightlight_round,
                  title: 'Mode gelap',
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
                _settingArrowTile(
                  icon: Icons.language,
                  title: 'Bahasa',
                  trailingText: _language,
                  onTap: () {
                    setState(() {
                      _language =
                          _language == 'Indonesia' ? 'English' : 'Indonesia';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            _settingsSection(
              title: 'Keamanan',
              children: [
                _settingArrowTile(
                  icon: Icons.lock_outline,
                  title: 'Ganti kata sandi',
                  onTap: () {},
                ),
                _settingSwitchTile(
                  icon: Icons.lock,
                  title: 'Aktifkan pin',
                  value: _pinEnabled,
                  onChanged: (value) {
                    setState(() {
                      _pinEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _settingSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 22,
            child: Switch(
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingArrowTile({
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 38,
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: 'File Manager',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final WidgetBuilder pageBuilder;

  _MenuItem(this.icon, this.label, this.pageBuilder);
}

