package com.ccextractor.ultimate_alarm_clock

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.view.View
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
            val ringsIn = data.getString("rings_in", "No upcoming alarms!")
            val alarmTime = data.getString("alarm_time", "")
            val repeatDays = data.getString("alarm_repeat_days", "One Time")
            if (ringsIn == "No upcoming alarms!") {
                views.setViewVisibility(R.id.repeat_days, View.GONE)
                views.setViewVisibility(R.id.rings_in, View.GONE)
                views.setTextViewText(R.id.repeat_days, "")
                views.setTextViewText(R.id.alarm_date_n_time, "No upcoming alarms!")
                views.setTextViewText(R.id.rings_in, "")
            } else {
                views.setViewVisibility(R.id.repeat_days, View.VISIBLE)
                views.setViewVisibility(R.id.rings_in, View.VISIBLE)
                views.setTextViewText(R.id.repeat_days, repeatDays)
                views.setTextViewText(R.id.alarm_date_n_time, alarmTime)
                views.setTextViewText(R.id.rings_in, ringsIn)
            }

            // Handle feature icons visibility
            views.setViewVisibility(R.id.shared_alarm_icon, 
                if (data.getBoolean("isSharedAlarmEnabled", false)) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.location_icon, 
                if (data.getBoolean("isLocationEnabled", false)) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.activity_icon, 
                if (data.getBoolean("isActivityEnabled", false)) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.weather_icon, 
                if (data.getBoolean("isWeatherEnabled", false)) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.qr_icon, 
                if (data.getBoolean("isQrEnabled", false)) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.shake_icon, 
                if (data.getBoolean("isShakeEnabled", false)) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.maths_icon, 
                if (data.getBoolean("isMathsEnabled", false)) View.VISIBLE else View.GONE)
            views.setViewVisibility(R.id.pedometer_icon, 
                if (data.getBoolean("isPedometerEnabled", false)) View.VISIBLE else View.GONE)

        //     // handling on tap of add-alarm button
        //    val intent = Intent(context, MainActivity::class.java).apply {
        //        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        //    }
        //    val pendingIntent = PendingIntent.getActivity(
        //        context,
        //        0,
        //        intent,
        //        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        //    )
        //    views.setOnClickPendingIntent(R.id.add_alarm_button_next_alarm_widget, pendingIntent)
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