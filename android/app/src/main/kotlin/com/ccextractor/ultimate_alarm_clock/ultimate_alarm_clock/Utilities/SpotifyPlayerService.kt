package com.ccextractor.ultimate_alarm_clock

import android.app.Service
import android.content.Intent
import android.net.Uri
import android.os.IBinder


class SpotifyPlayerService : Service() {


    override fun onBind(p0: Intent?): IBinder? {
        TODO("Not yet implemented")
    }

    override fun onCreate() {
        super.onCreate()
        val spotifyIntent =
            Intent(Intent.ACTION_VIEW, Uri.parse("spotify:playlist:37i9dQZF1DXaTIN6XNquoW:play"))
        startActivity(spotifyIntent)

    }

}