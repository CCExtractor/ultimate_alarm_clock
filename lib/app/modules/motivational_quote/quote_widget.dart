import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

import '../../../../controllers/alarm_ring_controller.dart';
import 'package:flutter/material.dart';
import 'api_client.dart'; // Import the ApiClient class
import 'quote_model.dart'; // Import the Quote model
class QuoteWidget extends StatelessWidget {
  final ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: apiClient.fetchRandomQuote(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(snapshot.data!.quoteText, style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Text('- ${snapshot.data!.author}'),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Failed to fetch quote');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}