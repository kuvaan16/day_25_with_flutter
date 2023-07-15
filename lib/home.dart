import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'util/habit_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List habitList = [
    ["Exercise", false, 0, 1],
    ['Read', false, 0, 20],
    ['Meditate', false, 0, 20],
    ['code', false, 0, 4]
  ];
  Duration duration = Duration(minutes: 5);

  void habitStarted(int index) {
    var startTime = DateTime.now();
    int elapsedTime = habitList[index][2];
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (!habitList[index][1]) {
            timer.cancel();
          }
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
              ),
            ),
            child: Text(
              habitList[index][0],
              style: TextStyle(),
            ),
          ),
          content: Container(
            height: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily goal time for this habit",
                ),
                SizedBox(
                  height: 38,
                ),
                buildTimePicker(),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  habitList[index][3] = duration.inMinutes;
                  Navigator.pop(context);
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10, right: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Consistency is key."),
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              // Text(),
              HabitTitle(
                habitName: habitList[index][0],
                onTap: () {
                  habitStarted(index);
                },
                settingsTapped: () {
                  settingsOpened(index);
                },
                habitStarted: habitList[index][1],
                timeSpent: habitList[index][2],
                timeGoal: habitList[index][3],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildTimePicker() => SizedBox(
        height: 140,
        width: 250,
        child: CupertinoTimerPicker(
          initialTimerDuration: duration,
          mode: CupertinoTimerPickerMode.hm,
          onTimerDurationChanged: (duration) => setState(
            () {
              this.duration = duration;
            },
          ),
        ),
      );
}
