import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//mainはテスト用．
void main() {
  runApp(const GraphApp());
}

class GraphApp extends StatelessWidget {
  const GraphApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyGraphPage(),
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

class MyGraphPage extends StatefulWidget {
  const MyGraphPage({Key? key}) : super(key: key);

  @override
  State<MyGraphPage> createState() => _MyGraphPageState();
}

class _MyGraphPageState extends State<MyGraphPage> {
  late List<SampleData> datas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('グラフ画面'),
      ),

      body: GraphBody()
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
                          children: const <Widget>[
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
                                "15分!",
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

  //グラフ化する適当なサンプルデータ
  @override
  void initState() {
    datas = [
      SampleData("6/6-6/12", 480, 55),
      SampleData("6/13-6/19", 630, 90),
      SampleData("6/20-6/26", 700, 80),
      SampleData("6/27-7/3", 520, 50)
    ];
  }

  //棒グラフを描画
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
}

