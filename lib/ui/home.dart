import 'dart:math';
import 'package:benesse_team1/ui/HexToColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charts_flutter/flutter.dart' as charts;


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
  late List<SampleData> datas;



  @override
  void initState() {
    super.initState();
    print("initState");
    WidgetsBinding.instance.addObserver(this);
    _init();
    datas = [
      SampleData("6/6-6/12", 480, 55),
      SampleData("6/13-6/19", 630, 90),
      SampleData("6/20-6/26", 700, 80),
      SampleData("6/27-7/3", 520, 50)
    ];

  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('state = $state');
    if (state == AppLifecycleState.paused){
      if (nowStudying){
        debugPrint("ok");
        LeaveTime = DateTime.now();

        ShowAlertPlusSecond(0,10,"スマホ触ってから5分が経ちました","残り時間は${GoalMinute-5}分です");
        ShowAlertPlusSecond(1,20,"スマホ触ってから10分が経ちました","残り時間は${GoalMinute-10}分です");
        ShowAlertPlusSecond(2,30,"スマホ触ってから15分が経ちました","残り時間は${GoalMinute-15}分です");
        ShowAlertPlusSecond(3,40,"スマホ触ってから20分が経ちました","残り時間は${GoalMinute-20}分です");
        ShowAlertPlusSecond(4,50,"スマホ触ってから25分が経ちました","残り時間は${GoalMinute-25}分です");
      }
    }

    if (state == AppLifecycleState.resumed){
      AccumurateSmartPhoneTime += DateTime.now().difference(LeaveTime).inSeconds
      ;
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
      GraphBody(),
    ];
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: MakeAppbar(),
      body: _pages[pageindex],
      bottomNavigationBar: MakeBottonNavigationBar()
    );
  }

  Widget StartBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "さあ、勉強を始めよう！",
            style:GoogleFonts.mPlusRounded1c(
              fontSize: 24.0,
              color: Colors.black
            ),
          ),
          Image.asset("images/b08001.png",height: 200,),
          Container(
            height: 55.0,
            width: 244.0,
            decoration: BoxDecoration(
              color: HexColor("6acdca"),
              borderRadius: BorderRadius.circular(14.0)
            ),
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
              child: Text(
                "Start",
                style:  GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize:18.0
                  )
                ),
              ),
            ),
          ],
      ),
    );
  }
  Widget StudyingBody() {
    debugPrint(GoalMinute.toString());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ファイト！その調子だよ！",
            style:GoogleFonts.mPlusRounded1c(
                fontSize: 24.0,
                color: Colors.black
            ),
          ),
          Image.asset("images/b11501.png",height: 200,),
          Container(
            height: 55.0,
            width: 244.0,
            decoration: BoxDecoration(
                color: HexColor("ff70a2"),
                borderRadius: BorderRadius.circular(14.0)
            ),
            child: TextButton(
              onPressed: () =>
              {
                onPressedStudying()
              },
              child: Text(
                  "finish",
                  style:  GoogleFonts.mPlusRounded1c(
                    color: Colors.white,
                    fontSize:18.0
                  )
              ),
            ),
          ),
        ],
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
  Widget GraphBody(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: Left_lines(),
                ),
              ),
              const Text(
                "お疲れさま!",
                style: TextStyle(
                    fontSize: 24),
              ),
              Container(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: Right_lines(),
                ),
              ),
            ],
          ),

          Container(
              margin: const EdgeInsets.all(40),
              child: Column(
                  children: <Widget>[
                    Container(
                      child: const Text(
                        "スマホをさわった時間はなんと",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Center(
                      child: Stack(
                          children: <Widget>[
                            Center(
                              //文字の背景に線を引く部分
                              child: Text(
                                "_______",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 5,
                                    decorationColor: Color(0xff6acdca),
                                    fontSize: 40
                                ),
                              ),
                            ),

                            Center(
                              child: Text(
                                "${AccumurateSmartPhoneTime}分!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                            ),
                          ]
                      ),
                    ),
                    makeChart(datas),
                  ]
              )
          ),
        ],
      ),
    );
  }
  Widget makeChart(List<SampleData> datas) {
    List<charts.Series<SampleData, String>> _series = [
      charts.Series<SampleData, String>(
        id: "勉強時間",
        data: datas,
        domainFn: (_sample, _) => _sample.week,
        measureFn: (_sample, _) => _sample.study_time,
        // fillColorFn: (_sample, _) => charts.ColorUtil.fromDartColor(Color(0xffff70a2))
      ),
      charts.Series<SampleData, String>(
        id: "スマホ時間",
        data: datas,
        domainFn: (_sample, _) => _sample.week,
        measureFn: (_sample, _) => _sample.smartphone_time,
        // fillColorFn: (_sample, _) => charts.ColorUtil.fromDartColor(Color(0x80ff70a2))
      )
    ];
    return Container(
      height: 250,
      child: charts.BarChart(
        _series,
        behaviors: [
          charts.SeriesLegend(
            position: charts.BehaviorPosition.top, //凡例の表示位置
            desiredMaxColumns: 2, //凡例の並べ方の行数
            entryTextStyle: charts.TextStyleSpec( //凡例のテキストスタイル
              color: charts.ColorUtil.fromDartColor(Colors.black),
            ),
          ),
          charts.ChartTitle(
            '時間（分）',
            behaviorPosition: charts.BehaviorPosition.start, //縦軸なので左に表示
            titleOutsideJustification: charts.OutsideJustification
                .middleDrawArea,
            titleStyleSpec: charts.TextStyleSpec( //テキストスタイル
              color: charts.ColorUtil.fromDartColor(Colors.black),
              fontSize: 12,
            ),
          ),
        ],
        domainAxis: const charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              labelRotation: 45, //1 ラベルを回転
              labelStyle: charts.TextStyleSpec( //2 ラベルのスタイル
                  fontSize: 10
              ),
            )
        ),
        primaryMeasureAxis: charts.NumericAxisSpec( //縦軸
          tickProviderSpec: const charts.BasicNumericTickProviderSpec(
            zeroBound: true,
            desiredTickCount: 3,
          ),
          renderSpec: charts.GridlineRendererSpec(
            labelStyle: const charts.TextStyleSpec(
              fontSize: 10,
              color: charts.MaterialPalette.black,
            ),
            lineStyle: charts.LineStyleSpec(
                color: charts.ColorUtil.fromDartColor(Colors.grey)
            ),
          ),
        ),
      ),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      if (index == 1) {
        pageindex = 3;
        _selectedindex = index;
      } else {
        _selectedindex = index;
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
      pageindex = 3;
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
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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
            title: Text("目標時間(分)"),
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

  BottomNavigationBar MakeBottonNavigationBar(){
    return BottomNavigationBar(
      currentIndex: _selectedindex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Colors.white,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics,color: Colors.white,),
          label: 'Graph',
        ),
      ],
      backgroundColor: HexColor("50b1b8"),
    );
  }

  AppBar MakeAppbar() {
    return AppBar(
      title: Column(
        children: [
        Text(
          "ゆるスマ",
          style: GoogleFonts.mPlusRounded1c(
              textStyle: Theme.of(context).textTheme.headline4,
              color: HexColor("ffffff"),
              fontSize: 20.0
          )
        ),
          Text(
              "YURUTTOSUMATAIMA",
              style: GoogleFonts.mPlusRounded1c(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: HexColor("ffffff"),
                  fontSize: 8.0
              )
          ),
        ],
        ),
        centerTitle: true,
        backgroundColor: HexColor("50b1b8"),
      );
  }
}

class SampleData {
  String week;
  int smartphone_time;
  int study_time;

  SampleData(this.week, this.study_time, this.smartphone_time);
}

//「\\」の図をかくやつ
class Left_lines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color(0xff6acdca);
    paint.strokeWidth = 4;
    canvas.drawLine(Offset(25, 20), Offset(42, 37), paint);
    canvas.drawLine(Offset(20, 25), Offset(37, 42), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//「//」の図をかくやつ
class Right_lines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color(0xff6acdca);
    paint.strokeWidth = 4;
    canvas.drawLine(Offset(25, 20), Offset(8, 37), paint);
    canvas.drawLine(Offset(30, 25), Offset(13, 42), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

