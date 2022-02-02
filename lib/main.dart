

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trial0201/globals/colors_of_mood.dart';
import 'package:trial0201/globals/globals.dart';
import 'package:trial0201/globals/theming.dart';

import 'package:trial0201/screens/app_settings.dart';
import 'package:trial0201/screens/graphs.dart';
import 'package:trial0201/widgets/bottom_nav.dart';
import 'package:trial0201/screens/history.dart';
import 'package:trial0201/screens/main_screen.dart';

import 'package:trial0201/widgets/mood/log_mood_screen_1.dart';
import 'package:trial0201/widgets/mood/log_mood_screen_2.dart';
import 'package:trial0201/widgets/mood/log_mood_screen_3.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:provider/provider.dart';

const primaryColor = Colors.transparent;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyAppFirst());
}

class MyAppFirst extends StatelessWidget {
  const MyAppFirst({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {



    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => currentModel,
      child: Consumer<ThemeModel>(
        builder: (_, currentModel, __) {
          return MaterialApp(
            title: 'Blossom',
            initialRoute: '/',
            routes: {
              // When navigating to the "/" route, build the FirstScreen widget.
              '/': (context) => const MyApp(),

              //to multiselect mood log

              '/logmood1': (context) => const LogMoodScreen1(),

              '/logmood2': (context) => const LogMoodScreen2(),

              '/logmood3': (context) => const LogMoodScreen3(),

              //
              '/history': (context) => const ShowHistory(),

              //'/emotionSelectionScreen' : (context) => const EmotionSelectionScreen(),
            },
            theme: ThemeData(
                // Define the default brightness and colors.
                brightness: Brightness.light,
                primaryColor: Colors.deepPurple,

                // Define the default font family.
                fontFamily: 'Comfortaa',

                // Define the default `TextTheme`. Use this to specify the default
                // text styling for headlines, titles, bodies of text, and more.
                textTheme: textTextTheme.apply(
                  // bodyColor: Colors.orange,
                  displayColor: Colors.black,
                ),
                appBarTheme: const AppBarTheme(
                  //brightness: Brightness.light,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  color: Colors.white,
                  elevation: 1,
                )),

            darkTheme: ThemeData(
                // Define the default brightness and colors.
                brightness: Brightness.dark,
                primaryColor: const Color(0xFF151026),

                // Define the default font family.
                fontFamily: 'Comfortaa',

                //we add white text for dark theme
                textTheme: textTextTheme.apply(
                  // bodyColor: Colors.orange,
                  displayColor: Colors.white,
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 1,
                )),
            // Provide dark theme.
            themeMode: currentModel.mode,
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent
          //color set to transperent or set your own color
        ));

    */

    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //we save the userinput

//  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    ShowHistory(),
    GraphScreen(),
    AppSettings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      BottomNavi().changePage(index);
    });
  }

  // Map<SecondaryMoods, int> allMoodLogs = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Blossom",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           // Center(child: CircularProgressIndicator()),
            //widget to select the moods from
            // UserMood(),
            _widgetOptions.elementAt(selectedIndex),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.airplanemode_on_rounded),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('Users/3oD3lMeJuQr7UJ84aHp2/MoodEntries/MultipleEntries/OneEntry')
                .snapshots()
                .listen((data) {


              data.docs.forEach((element) {
                print(element['strength']);
                print(element['moodPrimary']);
                print(element['moodSecondary']);


              });
            });


          }),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            // canvasColor: Colors.green,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: const TextStyle(color: Colors.yellow))),
        // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          // backgroundColor: Colors.pink,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.bubble_chart_rounded),
              label: 'Home',
              //  backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: 'History',
              // backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Graphs',
              // backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.miscellaneous_services_rounded),
              label: 'Settings',
              // backgroundColor: Colors.white,
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class ThemeModel with ChangeNotifier {
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // _changeColorTheme(_mode);
    notifyListeners();
  }
}

void _changeColorTheme(ThemeMode mode) {
  if (mode == ThemeMode.light) {
    angryMoodColor = angryMoodColorLight;
    scaredMoodColor = scaredMoodColorLight;
    sadMoodColor = sadMoodColorLight;
    happyMoodColor = happyMoodColorLight;
    surprisedMoodColor = surprisedMoodColorLight;
    powerfulMoodColor = powerfulMoodColorLight;
    disgustedMoodColor = disgustedMoodColorLight;
    peacefulMoodColor = peacefulMoodColorLight;
  } else {
    angryMoodColor = angryMoodColorDark;
    scaredMoodColor = scaredMoodColorDark;
    sadMoodColor = sadMoodColorDark;
    happyMoodColor = happyMoodColorDark;
    surprisedMoodColor = surprisedMoodColorDark;
    powerfulMoodColor = powerfulMoodColorDark;
    disgustedMoodColor = disgustedMoodColorDark;
    peacefulMoodColor = peacefulMoodColorDark;
  }
}