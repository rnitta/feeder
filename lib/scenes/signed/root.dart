import 'package:flutter/material.dart';
import 'package:feeder/scenes/signed/ramify_route.dart';

class SignedRoot extends Scaffold {
  EsaTeam teama;
  factory SignedRoot(EsaTeam team) {
    int _selectedIndex = 1;
    final _tabs = [
      Text('Index 0: Home'),
      Text('Index 1: Business'),
      Text('Index 2: School'),
    ];
    final instance = Scaffold(
        appBar: AppBar(
          title: Text(team.name),
        ),
        body: Center(
          child: _tabs.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.business), title: Text('Business')),
            BottomNavigationBarItem(
                icon: Icon(Icons.school), title: Text('School')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.deepPurple,
          onTap: _onTabTapped,
        ));
    return instance;
  }

  static void _onTabTapped(int n) {
    print(n);
  }
}
