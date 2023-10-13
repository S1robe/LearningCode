import 'package:flutter/material.dart';

void main() => runApp(const RootApp());

class RootApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier
                                        = ValueNotifier(ThemeMode.system);
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode current, child) {
         return MaterialApp(
           themeMode: current,
           theme: ThemeData(
             useMaterial3: true,
             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
               brightness: Brightness.light,
               background: Colors.white,
             ),
             textTheme: const TextTheme(
               bodyMedium: TextStyle(color: Colors.deepPurpleAccent),
             ),
           ),
           darkTheme: ThemeData.dark().copyWith(
               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange).copyWith(
                   brightness: Brightness.dark,
                   background: Colors.black54
               ),
               textTheme: TextTheme(
                   bodyMedium: TextStyle(color: Colors.deepOrange[200])
               )
           ),
           routes: {
             '/': (context) => SplashScreen(),
             '/dashboard': (context) => Dashboard(),
             '/calendar': (context) => Calendar(),
             '/entries': (context) => Entries(),
//    '/plans': (context) => Entries(plans: true),
           },
           //initialRoute: '/dashboard',
         );
      },
    );
  }

}

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black,
                width: 3.0,
            )
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/loadingscreen.png',
                  scale: 4
              ),
              SizedBox(height: 20.0),
              Text('Pocket Therapist is loading',
                textAlign: TextAlign.center,

                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20.0),
              CircularProgressIndicator(color: Colors.amber),
              SizedBox(height: 50.0),
              AnimatedContainer(duration: duration)
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                },
              )
            ]
        ),
      ),
    );

  }



}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return  AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      actions: [
        ElevatedButton(onPressed: (){

        }, child: Text('1')),
        FloatingActionButton(onPressed: (){
          Navigator.pop(context);
        })
      ],
    );
  }
}

class Calendar extends StatefulWidget {

  @override
  _CalendarState createState() => _CalendarState();
}
class _CalendarState extends State<Calendar> {
  // Put all the variabels that we need for the calendar page here...


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red,
                    child: const Text('Upper Half'),
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.blue,
                    child: const Text('Lower Half'),
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

class Entries extends StatefulWidget {

  @override
  _EntriesState createState() => _EntriesState();
}
class _EntriesState extends State<Entries> {
  // Put all the variabels that we need for the calendar page here...


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.red,
                  child: const Text('Upper Half'),
                ),
              ),
            ],
          ),
        )
    );

  }
}

// New entry page, make it an overlay (AppBar)
class NewEntry extends StatefulWidget {

  @override
  _NewEntryState createState() => _NewEntryState();

}
class _NewEntryState extends State<NewEntry> {

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

}

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}
class _SettingsState extends State<Settings> {
  // Put all the variabels that we need for the settings page here...

  @override
  Widget build(BuildContext context) {
    return AppBar(

    );
  }
}