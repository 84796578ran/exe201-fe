import 'package:flutter/material.dart';
import 'package:roomspot/Pages/provider_page/post_list/provider_post_list.dart';

import 'components/provider_more_menu.dart';

class ProviderNavbar extends StatefulWidget {
  const ProviderNavbar({super.key});

  @override
  State<ProviderNavbar> createState() => _ProviderNavbarleState();
}

class _ProviderNavbarleState extends State<ProviderNavbar> {
  int currentPageIndex = 0;
  final GlobalKey<ProviderPostListState> postListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        surfaceTintColor: Colors.white,
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.add_home),
            ),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notification_add_outlined)),
            label: 'Thông báo',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Tin nhắn',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.boy),
            ),
            label: 'Thông tin cá nhân',
          ),
        ],
      ),
      body: Stack(
        children: [
          [
            ProviderPostList(key: postListKey),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.notifications_sharp),
                      title: Text('Notification 1'),
                      subtitle: Text('This is a notification'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.notifications_sharp),
                      title: Text('Notification 2'),
                      subtitle: Text('This is a notification'),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              reverse: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Hello',
                        style: theme.textTheme.bodyLarge!
                            .copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  );
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Hi!',
                      style: theme.textTheme.bodyLarge!
                          .copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ),
                );
              },
            ),
            Center(
              child: Text(
                'Thông tin cá nhân',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ][currentPageIndex],
          ProviderMoreMenu(
            onCreatePostSuccess: () {
              if (postListKey.currentState != null) {
                postListKey.currentState!.loadPosts();
              }
            },
          ),
        ],
      ),
    );
  }
}
