import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTitle extends StatefulWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int timeSpent;
  final int timeGoal;
  final bool habitStarted;

   HabitTitle({
    super.key,
    required this.habitName,
    required this.onTap,
    required this.settingsTapped,
    required this.timeSpent,
    required this.timeGoal,
    required this.habitStarted,
  });

  @override
  State<HabitTitle> createState() => _HabitTitleState();
}

class _HabitTitleState extends State<HabitTitle> {
 

  String FormatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(5);
    if (secs.length == 1) {
      secs = '0' + secs;
    }
    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }
    return mins + ':' + secs;
  }

  double percentCompleted() {
    return widget.timeSpent / (widget.timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: [
                        CircularPercentIndicator(
                          radius: 30,
                          lineWidth: 10,
                          backgroundColor: Colors.white,
                          percent:
                              percentCompleted() < 1 ? percentCompleted() : 1,
                          progressColor: percentCompleted() >= .5
                              ? (percentCompleted() >= .75
                                  ? Colors.green
                                  : Colors.orange)
                              : Colors.red,
                        ),
                        Center(
                          child: Icon(
                            widget.habitStarted ? Icons.pause : Icons.play_arrow,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habitName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          FormatToMinSec(widget.timeSpent),
                          style: TextStyle(
                              color: widget.habitStarted ? Colors.black : Colors.grey),
                        ),
                        Text(
                          ' / ' +
                              widget.timeGoal.toString() +
                              " mins = " +
                              (percentCompleted() * 100).toStringAsFixed(0) +
                              "%",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: widget.settingsTapped,
              child: Icon(Icons.settings),
            ),
            
          ],
        ),
      ),
    );
  }
}
