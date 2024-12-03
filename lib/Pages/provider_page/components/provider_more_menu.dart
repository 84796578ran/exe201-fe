import 'package:flutter/material.dart';

import '../create_post_screen/create_post_page.dart';
import '../order_list/provider_order_list_screen.dart';

class ProviderMoreMenu extends StatefulWidget {
  final Function() onCreatePostSuccess;

  const ProviderMoreMenu({
    super.key,
    required this.onCreatePostSuccess,
  });

  @override
  State<ProviderMoreMenu> createState() => _ProviderMoreMenuState();
}

class _ProviderMoreMenuState extends State<ProviderMoreMenu> {
  bool isExpanded = false;
  final Color menuColor = Colors.blue;

  late final List<MenuOption> menuOptions = [
    MenuOption(
      icon: Icons.add_home,
      label: 'Tạo bài đăng',
      color: menuColor,
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePostPage()),
        );
        if (result == true) {
          widget.onCreatePostSuccess();
        }
      },
    ),
    MenuOption(
      icon: Icons.receipt_long,
      label: 'Đơn đặt phòng',
      color: menuColor,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProviderOrderListScreen(),
          ),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Backdrop
        if (isExpanded)
          GestureDetector(
            onTap: () => setState(() => isExpanded = false),
            child: Container(
              color: Colors.black12,
            ),
          ),
        // Menu options
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          bottom: isExpanded ? 80 : -200,
          left: 0,
          right: 0,
          child: Center(
            child: Wrap(
              spacing: 20,
              children: menuOptions.map((option) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: option.color,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() => isExpanded = false);
                          option.onTap();
                        },
                        icon: Icon(
                          option.icon,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        // Main button
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: menuColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => setState(() => isExpanded = !isExpanded),
                icon: AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isExpanded ? 0.125 : 0,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MenuOption {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  MenuOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
