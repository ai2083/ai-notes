import 'package:flutter/material.dart';
import 'notes_list_page.dart';
import 'chat_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Me tab is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              color: const Color(0xFFF1F5F9),
              child: Row(
                children: [
                  // Avatar in header
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBeYF-KFpCiXaw51pQL7WyAoC8xysJd3HofKlZylYHYBRgkAyGyGSAf3XqqAOVmmvt_V2lDtcO_dRjo1DFTO_45urPOsHDDbCohVVGcFfM1ibvwykFFfv9oMziMvtTyAvIWq9IEtRY0i-SahQAMrtkvJo9LqmeiJJBvdKt3lQAZHwi4qp39R-EqmqcXFi7rjeguqmSQIezQ07pdlaB9n_h6t5RZkOS-mr8qeensZjsMeQf72bQqSGQVGD-yTHTEWcNtxw8P6H9q9s4d',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Me',
                        style: TextStyle(
                          color: Color(0xFF0D141B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the avatar space
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Large Profile Picture
                          Container(
                            width: 128,
                            height: 128,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDvRLN9T4IXuzprVtW1iuJcK0cGoEkZZezuXWPLfAS-wtonDzpmIQYgd2xZtbOfJyZzt2PXaXRTe01ztryh3fG7ca4SvldP8dw3NaKcZ2BV5_STAaQficx6039gHlWQFirtFWfrovvO3zC3qPjzEU4FsbO1G-5651gEZpzb8zR1pBfOO3JHGyayeEfD8_Fj2uc1e5DgeEGijD690Dchrd5noaKHkbgirgGOt4C5aRvZskUtROKRe1q8lQz6PsFt2onTEHtlFRkUnGAO',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // User Info
                          const Column(
                            children: [
                              Text(
                                'Sophia Carter',
                                style: TextStyle(
                                  color: Color(0xFF0D141B),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.015,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Premium',
                                style: TextStyle(
                                  color: Color(0xFF4C739A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Joined in 2022',
                                style: TextStyle(
                                  color: Color(0xFF4C739A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Account Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
                            child: Text(
                              'Account',
                              style: TextStyle(
                                color: Color(0xFF0D141B),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.015,
                              ),
                            ),
                          ),
                          
                          // Account Options
                          _buildMenuItem(
                            icon: Icons.star_outline,
                            title: 'Upgrade to Premium',
                            onTap: () {
                              // Handle upgrade to premium
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.people_outline,
                            title: 'Invite Friends',
                            onTap: () {
                              // Handle invite friends
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            onTap: () {
                              // Handle settings
                            },
                          ),
                          _buildMenuItem(
                            icon: Icons.help_outline,
                            title: 'Help & Feedback',
                            onTap: () {
                              // Handle help & feedback
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE7EDF3), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0) {
              // Navigate to home
              Navigator.pop(context);
            } else if (index == 1) {
              // Navigate to chat page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ),
              );
            } else if (index == 2) {
              // Navigate to notes list page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotesListPage(),
                ),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFF1F5F9),
          selectedItemColor: const Color(0xFF0D141B),
          unselectedItemColor: const Color(0xFF4C739A),
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.015,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.015,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_outlined),
              activeIcon: Icon(Icons.note),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: 'Me',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Material(
        color: const Color(0xFFF1F5F9),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7EDF3),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF0D141B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF0D141B),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
