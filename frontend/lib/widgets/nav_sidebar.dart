import 'package:flutter/material.dart';
import 'package:system_monitoring_project/theme/app_theme.dart';

class NavSidebar extends StatelessWidget {
  final String currentPage;

  const NavSidebar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Color(0xFF11142B),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // App logo and title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.developer_board_outlined,
                    color: Color(0xFF4ECDC4),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'SysMonitor',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Navigation items
          _buildNavItem(
            context,
            'dashboard',
            'Dashboard',
            Icons.dashboard_outlined,
            Icons.dashboard,
          ),
          _buildNavItem(
            context,
            'alerts',
            'Alerts',
            Icons.notifications_outlined,
            Icons.notifications,
          ),
          _buildNavItem(
            context,
            'servers',
            'Servers',
            Icons.dns_outlined,
            Icons.dns,
          ),
          _buildNavItem(
            context,
            'services',
            'Services',
            Icons.miscellaneous_services_outlined,
            Icons.miscellaneous_services,
          ),
          _buildNavItem(
            context,
            'logs',
            'Logs',
            Icons.description_outlined,
            Icons.description,
          ),
          _buildNavItem(
            context,
            'settings',
            'Settings',
            Icons.settings_outlined,
            Icons.settings,
          ),
          const Spacer(),
          // User profile section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF4ECDC4).withOpacity(0.2),
                  child: const Text(
                    'JD',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Logout or user settings action
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                  tooltip: 'Logout',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String page,
    String title,
    IconData outlinedIcon,
    IconData filledIcon,
  ) {
    final bool isSelected = currentPage == page;

    return InkWell(
      onTap: () {
        if (!isSelected) {
          // Navigate to the page
          Navigator.pushReplacementNamed(context, '/$page');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF4ECDC4).withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? const Color(0xFF4ECDC4) : Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4ECDC4) : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (page == 'alerts') const Spacer(),
            if (page == 'alerts')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
