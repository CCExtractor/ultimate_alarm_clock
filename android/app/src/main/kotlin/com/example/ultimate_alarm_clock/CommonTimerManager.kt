package com.example.ultimate_alarm_clock

import android.os.CountDownTimer

object CommonTimerManager {
    private var commonTimer: CommonTimer? = null

    fun getCommonTimer(listener: TimerListener): CommonTimer {
        if (commonTimer == null) {
            commonTimer = CommonTimer(listener)
        }
        return commonTimer!!
    }
}
class CommonTimer(private val listener: TimerListener) {
    private var timer: CountDownTimer? = null

    fun startTimer(durationMillis: Long) {
        timer?.cancel() // Cancel any existing timer
        timer = object : CountDownTimer(durationMillis, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                listener.onTick(millisUntilFinished)
            }

            override fun onFinish() {
                listener.onFinish()
            }
        }.start()
    }

    fun stopTimer() {
        timer?.cancel()
    }
}

interface TimerListener {
    fun onTick(millisUntilFinished: Long)
    fun onFinish()
}
