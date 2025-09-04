package com.ccextractor.ultimate_alarm_clock.communication

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.android.gms.wearable.*
import com.google.gson.Gson
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class UACDataLayerListenerService : WearableListenerService() {
    private val TAG = "UAC_DataLayerService"
    private val CHANNEL_NAME = "com.ccextractor.uac/alarm_actions"
    private val PATH_ACTION_WATCH_TO_PHONE = "/uac_watch_to_phone/action"
    private val PATH_ALARM_WATCH_TO_PHONE = "/uac_watch_to_phone/alarm"

    private val mainThreadHandler = Handler(Looper.getMainLooper())

    companion object {
        var flutterEngine: FlutterEngine? = null
    }

    override fun onCreate() {
        super.onCreate()
    }

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        Log.d(TAG, "📡 Phone receivers triggered")

        for (event in dataEvents) {
            if (event.type != DataEvent.TYPE_CHANGED) continue

            val item = event.dataItem
            val path = item.uri.path ?: continue
            val dataMap = DataMapItem.fromDataItem(item).dataMap

            Log.d(TAG, "➡ Path: $path | data: $dataMap")

            when {
                // ! alarm received is send to the flutter side
                path == PATH_ALARM_WATCH_TO_PHONE -> {
                    val json = dataMap.getString("alarm_json")
                    val isNewAlarm = dataMap.getBoolean("isNewAlarm", true)
                    val dto = Gson().fromJson(json, FullAlarmDTO::class.java)
                    val fullAlarm = dto.toAlarmModel()
                    Log.d(TAG, "Background Alarm Received: isNewAlarm=$isNewAlarm, fullAlarm=$fullAlarm")

                    mainThreadHandler.post {
                        flutterEngine?.let {
                            ReceivedAlarmModelToDb.sendToFlutter(it, fullAlarm, isNewAlarm)
                        }
                                ?: Log.w(TAG, "⚠️ flutterEngine not available for alarm sync.")
                    }
                }

                path == PATH_ACTION_WATCH_TO_PHONE -> {
                    val action = dataMap.getString("action")
                    val alarmId = dataMap.getString("uniqueSyncId")
                    val timestamp = dataMap.getLong("timestamp")

                    Log.d(TAG, "Received Action: '$action' for alarmId: $alarmId at $timestamp")

                    mainThreadHandler.post {
                        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                            MethodChannel(messenger, CHANNEL_NAME)
                                    .invokeMethod(
                                            "handleReceivedAction",
                                            mapOf("action" to action, "alarmId" to alarmId)
                                    )
                        }
                                ?: Log.w(TAG, "⚠️ flutterEngine not available for action sync.")
                    }
                }
            }
        }
    }
}