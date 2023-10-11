import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          
        ),
        home: MyHomePage(),
      ),
    );
  }
}

/*
This is a change notifier, as its name suggests, it notifies any listeners
of changes, but only if the notifyListeners() method is called

*/
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // Define a list of word Pairs
  var favorites = <WordPair>[];
  void toggleFavorite() {
    if(favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}


class _MyHomePageState extends State<MyHomePage> {
  
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch(selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage(); 
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row( 
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 800,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home), 
                    label: Text('Home'),
                    ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite), 
                    label: Text('Favorites'), 
                    ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                      selectedIndex = value;  
                      });
                  },
                ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
                )
            ),
          ],
        ),
      );
    });
  }
}

/*
This is a widget that doesnt have state because it doesnt change
Stateless widgets seem to be used to hold other stateful widgets.

That is to say that stateless widgets would house listeners and watch on 
stateful widgets, but nothing would watch on them...
*/
class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState(); 
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context ) {
    var appState = context.watch<MyAppState>();
    
    List<ListTile> favoritesListTiles = <ListTile>[];
    for (WordPair pair in appState.favorites){
      favoritesListTiles.add(ListTile(
            title: Text(pair.asString),
            onTap: () {
              appState.favorites.remove(pair);
              favoritesListTiles.remove(this);
            },
        ));
    }

    
    return Center(
      child: ListView(
        children: favoritesListTiles,
      ),
    );

  }

}


class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    IconData icon = appState.favorites.contains(pair) ? 
                        Icons.star_border_sharp:
                        Icons.star_sharp;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text('Favorite'),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  appState.getNext();
                }, 
                icon: Icon(Icons.arrow_right),
                label: const Text('Next')
              )
            ]
          )
        ]
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard ({
    super.key,
    required this.pair, // The word pair to return.
  });

  final WordPair pair;

  // This method is in every widget, it is called whenever something
  // needs to be redrawn or updated.
  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child : Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

