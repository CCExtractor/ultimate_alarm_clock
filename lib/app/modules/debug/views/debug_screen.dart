import 'package:flutter/material.dart';
import 'dart:async';

import '../../../data/providers/isar_provider.dart';

class DebugScreen extends StatefulWidget {
  @override
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<DebugScreen> {
  List<Map<String, dynamic>> logs = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Fetch logs immediately when the screen loads
    fetchLogs();
    // Set up a timer to refresh logs every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchLogs();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchLogs() async {
    final logs = await IsarDb().getLogs();
    setState(() {
      this.logs = logs.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,),
      backgroundColor: Colors.black, // Black background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            final logTime = DateTime.fromMillisecondsSinceEpoch(log['LogTime']);
            final formattedTime =
                '${logTime.year}-${logTime.month.toString().padLeft(2, '0')}-${logTime.day.toString().padLeft(2, '0')} ${logTime.hour.toString().padLeft(2, '0')}:${logTime.minute.toString().padLeft(2, '0')}:${logTime.second.toString().padLeft(2, '0')}';
            return Text(
              'LogID: ${log['LogID']},\nLogTime: $formattedTime, \nStatus: ${log['Status']}\n',
              style: TextStyle(
                color: Colors.green, // Green text
                fontSize: 16,
                fontFamily: 'Courier', // Monospace font for terminal look
              ),
            );
          },
        ),
      ),
    );
  }
}
