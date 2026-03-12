package com.pravera.fl_location

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger

/** FlLocationPluginChannel */
interface FlLocationPluginChannel {
	fun initChannel(messenger: BinaryMessenger)
	fun setActivity(activity: Activity?)
	fun disposeChannel()
}
