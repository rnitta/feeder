import 'package:flutter/material.dart';
import 'package:feeder/scenes/signed/ramify_team.dart';

class SignedRoot extends Scaffold {
  EsaTeam team;
  static final _tabs = [
    Text('Index 0: Home'),
    Text('Index 1: Business'),
    Text('Index 2: School'),
  ];
  SignedRoot()
      : super(
            appBar: AppBar(
              title: Text('title'),
            ),
            body: Center(
              child: _tabs.elementAt(1),
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
              currentIndex: 1,
              fixedColor: Colors.deepPurple,
              onTap: _onTabTapped,
            ));

  static void _onTabTapped(int n) {
    print(n);
  }
}
