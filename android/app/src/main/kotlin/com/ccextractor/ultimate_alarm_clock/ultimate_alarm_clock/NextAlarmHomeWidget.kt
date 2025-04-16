package com.ccextractor.ultimate_alarm_clock

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin


class NextAlarmHomeWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            // Handling next alarm content
            val data = HomeWidgetPlugin.getData(context);
            val views = RemoteViews(context.packageName, R.layout.next_alarm_home_widget)
            var ringsIn = data.getString("rings_in", "No upcoming alarms!")
            var alarmTime = data.getString("alarm_time", "")
            if (ringsIn == "No upcoming alarms!") {
                alarmTime = "No upcoming alarms!";
                ringsIn = "";
            }
            views.setTextViewText(R.id.rings_in, ringsIn)
            views.setTextViewText(R.id.alarm_date_n_time, alarmTime)
            // handling on tap of add-alarm button
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            views.setOnClickPendingIntent(R.id.add_alarm_button_next_alarm_widget, pendingIntent)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}