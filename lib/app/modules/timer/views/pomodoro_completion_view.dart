import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/timer/views/pomodoro_timer_view.dart';


class CompletionScreen extends StatelessWidget {
  final String type; // 'work' or 'break'
  final int duration;
  final int? currentInterval; // Optional parameter for current interval
  final int? totalIntervals; // Optional parameter for total intervals
  
  CompletionScreen({
    required this.type,
    required this.duration,
    this.currentInterval,
    this.totalIntervals,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: type == 'work' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    type == 'work' ? Icons.emoji_emotions : Icons.coffee,
                    color: type == 'work' ? Colors.green : Colors.orange,
                    size: 70,
                  ),
                ),
              ),
             
              SizedBox(height: 30),
             
              // Great! text
              Text(
                "Great!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
             
              SizedBox(height: 20),
             
              // Message
              Text(
                type == 'work'
                  ? "You've completed a $duration-minute work session!"
                  : "Break time complete! Ready to get back to work?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
             
              SizedBox(height: 40),
             
              // Continue Button
              GestureDetector(
                onTap: () => Get.to(PomodoroPage()),
                child: Container(
                  width: 180,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: type == 'work' ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (type == 'work' ? Colors.green : Colors.orange).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
             
              SizedBox(height: 30),
             
              // Small text at bottom
              Text(
                "Taking regular breaks helps reduce eye strain and mental fatigue",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}