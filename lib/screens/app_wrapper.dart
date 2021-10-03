import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunshiner/models/state_model.dart';
import 'package:sunshiner/screens/dashboard.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Provider<StateModel>(
      create: (BuildContext context) => StateModel(),
      builder: (BuildContext context, _) {
        return Scaffold(
          body: IndexedStack(
            index: _index,
            children: [
              Dashboard(),
              Container(color: Colors.red),
              Container(color: Colors.blue)
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: (int i) => setState(() => _index = i),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.map_rounded), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_rounded), label: 'More'),
            ],
          ),
        );
      },
    );
  }
}
