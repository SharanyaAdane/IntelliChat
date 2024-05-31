import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'addusers.dart';
import 'profilepage.dart';
import 'chatscreen.dart'; // Import the ChatScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Set the initial value to 0 for the chat page
  final List<String> _chatList = [
    'Chat 1',
    'Chat 2',
    'Chat 3',
    'Chat 4',
    // temporary chat names
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chats',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              },
              icon: Icon(
                Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality here
              },
            ),
          ],
        ),
        body: _buildBody(), // Update body to render different screens
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add User',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Update selected index on tap
            });
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return ListView.builder(
          itemCount: _chatList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_chatList[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            );
          },
        );
      case 1:
        return ProfileScreen();
      case 2:
        return AddUserScreen();
      default:
        return ListView.builder(
          itemCount: _chatList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_chatList[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            );
          },
        );
    }
  }
}
