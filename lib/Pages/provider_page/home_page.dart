import 'package:flutter/material.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

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
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.home_outlined),
            label: 'Tìm kiếm',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.heart_broken)),
            label: 'Yêu thích',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.add_home),
            ),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.messenger_sharp),
            ),
            label: 'Tin nhắn',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('5'),
              child: Icon(Icons.boy),
            ),
            label: 'Thông tin cá nhân',
          ),
        ],
      ),
      body: [
        /// Trang "Tìm kiếm"
        Center(
          child: Text(
            'Tìm kiếm',
            style: theme.textTheme.titleLarge,
          ),
        ),

        /// Trang "Yêu thích"
        Center(
          child: Text(
            'Yêu thích',
            style: theme.textTheme.titleLarge,
          ),
        ),

        /// Trang "Trang chủ"
        Center(
          child: Text(
            'Trang chủ',
            style: theme.textTheme.titleLarge,
          ),
        ),

        /// Trang "Tin nhắn"
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

        /// Trang "Thông tin cá nhân"
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
      ][currentPageIndex],
    );
  }
}
