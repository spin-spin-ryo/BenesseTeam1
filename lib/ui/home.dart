import 'dart:ffi';
import 'dart:math';

import 'package:benesse_team1/ui/Graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';


MaterialColor box_color = Colors.grey;


class Home extends StatefulWidget{
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> with WidgetsBindingObserver{


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  int _selectedindex = 0;
  int pageindex = 0;
  bool nowStudying = false;
  bool finishStudying = false;
  DateTime StartTime = DateTime.now();
  int StudyingMinite = 0;
  int GoalMinute = -1;
  int AccumurateSmartPhoneTime = 0;
  DateTime LeaveTime = DateTime.now();



  @override
  void initState() {
    super.initState();
    print("initState");
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('state = $state');
    if (state == AppLifecycleState.paused){
      if (nowStudying){
        debugPrint("ok");
        LeaveTime = DateTime.now();
        ShowAlertPlusSecond(0,300,"test1","test2");
        ShowAlertPlusSecond(1,600,"test1","test2");
        ShowAlertPlusSecond(2,900,"test1","test2");
        ShowAlertPlusSecond(3,1200,"test1","test2");
        ShowAlertPlusSecond(4,1500,"test1","test2");
      }
    }

    if (state == AppLifecycleState.resumed){
      AccumurateSmartPhoneTime += DateTime.now().difference(LeaveTime).inMinutes;
      await flutterLocalNotificationsPlugin.cancelAll();
    }

  }

  @override
  Widget build(BuildContext context) {
    // UIの部分はここに書く。　
    final _pages = <Widget>[
      StartBody(),
      StudyingBody(),
      ResultBody(),
      const Graph(),
    ];
    return Scaffold(
      body: _pages[pageindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedindex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'analytics',
          ),
        ],
      ),
    );
  }

  Widget StartBody() {
    return Center(
      child: Container(
        color: box_color,
        child: TextButton(
          onPressed: () =>
          {
            InputDialog(context),
            setState(() {
              pageindex = 1;
              nowStudying = true;
              StartTime = DateTime.now();
            })
          },
          child: const Text(
            "勉強開始",
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
      ),
    );
  }

  Widget StudyingBody() {
    debugPrint(GoalMinute.toString());
    return Center(
      child: Container(
        color: box_color,
        child: TextButton(
          onPressed: () =>
          {
            onPressedStudying()
          },
          child: Text("勉強終了"),
        ),
      ),
    );
  }

  Widget ResultBody() {
    return Center(
      child: Container(
          color: box_color,
          child: Text("お疲れ様でした")
      ),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      if (index == 1) {
        pageindex = 3;
      } else {
        if (nowStudying) {
          pageindex = 1;
        } else {
          pageindex = 0;
        }
      }
    });
  }

  onPressedStudying(){
    setState(() {
      StudyingMinite = DateTime
          .now()
          .difference(StartTime)
          .inMinutes;
      debugPrint(StudyingMinite.toString());
      pageindex = 2;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        pageindex = 0;
        nowStudying = false;
      });
    });
    SaveDate();
  }

  Future<void> SaveDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String Today= DateTime.now().year.toString() + DateTime.now().month.toString() + DateTime.now().day.toString();
    int _count = prefs.getInt(Today+"Study") ?? 0;
    await prefs.setInt(Today+"Study", _count + StudyingMinite - AccumurateSmartPhoneTime);
    _count = prefs.getInt(Today+"SmartPhone") ?? 0;
    await prefs.setInt(Today+"SmartPhone", _count + AccumurateSmartPhoneTime);
  }

  Future<void> _init() async {
    await _configureLocalTimeZone();
    await _initializeNotification();
  }

  Future<void> _initializeNotification() async {
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    var tokyo = tz.getLocation('Asia/Tokyo');
    tz.setLocalLocation(tokyo);
  }
  Future<void> ShowAlertPlusSecond(int index,int second, String message1, String message2) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        index,
        message1,
        message2,
        tz.TZDateTime.now(tz.local).add(Duration(seconds: second)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> InputDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("目標時間"),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => {
                setState((){
                  if (value.length!=0){
                    GoalMinute = int.parse(value);
                  }
                })
              },
            ),
              actions:<Widget>[
                ElevatedButton(
                  child: Text('開始'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )]
          );
        }
    );
  }
}


