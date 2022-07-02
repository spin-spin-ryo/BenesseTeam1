import 'package:flutter/material.dart';

class TestTimer extends StatefulWidget{
  @override
  _TestTimer createState() => _TestTimer();
}

class _TestTimer extends State<TestTimer>{
  bool nowStudying = false;
  DateTime StartDate = DateTime.now();
  int dif = 0;

  @override
  Widget build(BuildContext context) {
    // UIの部分はここに書く。　
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer"),
      ),
      body: Container(
        height: 100,
        width: 100,
        child: ElevatedButton(
          onPressed: () => FirstTimer_action(nowStudying),
          child: Text("$dif"),
        ),
      ),
    );
  }

    void FirstTimer_action(bool nowStudying) {
    if (!nowStudying){
      StartDate = DateTime.now();
      setState(() {
        nowStudying = true;
      });
    }else{
      // int dif = StartDate.difference(DateTime.now()).inSeconds;
      debugPrint(dif.toString());
      setState(() {
        dif = StartDate.difference(DateTime.now()).inSeconds;
        nowStudying = false;
      });
    }
  }
}
