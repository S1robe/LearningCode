import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    int _selectedIndex = 0;

    @override
    Widget build(BuildContext context){
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple,
                        brightness: Brightness.dark,
                      ),
          primaryColor: Colors.purple,
        ),
        routes: <String, WidgetBuilder>{
          '/' : (BuildContext context) {
              return FrontPanel(); 
            },
          '/Entry': (BuildContext context) {
              return const Placeholder();
            }

        }
      );
    }
}

class FrontPanel extends StatelessWidget {
  const FrontPanel({super.key});
 
  


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            elevation: 2,
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.tv),
                label: Text("Watch TV"),
              ),
            ],

            : [

            ],
          ),
        ],
      )
    ) 
  }

}
              ElevatedButton(
                onPressed: () {debugPrint("Button Pressed!");},
                child: const Text('Hi there!'),
              )
