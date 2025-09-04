// actually fetches the weather data from the API for the companion app
package com.ccextractor.ultimate_alarm_clock

import android.content.Context
import android.util.Log
import com.android.volley.toolbox.Volley
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class WeatherHelper(private val context: Context) {

    suspend fun fetchCurrentWeather(latitude: Double, longitude: Double): String? {
        val url = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=rain,snowfall,cloud_cover,wind_speed_10m"
        Log.d("WeatherHelper", "Fetching weather from: $url")

        return suspendCancellableCoroutine { continuation ->
            val request = GsonRequest(url, WeatherModel::class.java,
                { response ->
                    val currentWeather = when {
                        (response.current?.rain ?: 0.0) > 0.1 && (response.current?.windSpeed10m ?: 0.0) > 40.0 -> "stormy"
                        (response.current?.rain ?: 0.0) > 0.1 -> "rainy"
                        (response.current?.cloudCover ?: 0) > 60 -> "cloudy"
                        (response.current?.windSpeed10m ?: 0.0) > 20.0 -> "windy"
                        else -> "sunny"
                    }
                    Log.d("WeatherHelper", "API Success. Current weather is: $currentWeather")
                    if (continuation.isActive) continuation.resume(currentWeather)
                },
                { error ->
                    Log.e("WeatherHelper", "API Error: ${error.message}")
                    if (continuation.isActive) continuation.resume(null)
                })

            continuation.invokeOnCancellation { request.cancel() }
            
            Volley.newRequestQueue(context).add(request)
        }
    }
}