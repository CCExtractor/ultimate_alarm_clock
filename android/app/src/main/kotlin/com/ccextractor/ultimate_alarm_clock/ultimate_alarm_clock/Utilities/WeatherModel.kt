package com.ccextractor.ultimate_alarm_clock

import com.google.gson.annotations.SerializedName


data class WeatherModel (

    @SerializedName("latitude"              ) var latitude             : Double?       = null,
    @SerializedName("longitude"             ) var longitude            : Double?       = null,
    @SerializedName("generationtime_ms"     ) var generationtimeMs     : Double?       = null,
    @SerializedName("utc_offset_seconds"    ) var utcOffsetSeconds     : Int?          = null,
    @SerializedName("timezone"              ) var timezone             : String?       = null,
    @SerializedName("timezone_abbreviation" ) var timezoneAbbreviation : String?       = null,
    @SerializedName("elevation"             ) var elevation            : Int?          = null,
    @SerializedName("current_units"         ) var currentUnits         : CurrentUnits? = CurrentUnits(),
    @SerializedName("current"               ) var current              : Current?      = Current()

)

data class CurrentUnits (

    @SerializedName("time"           ) var time         : String? = null,
    @SerializedName("interval"       ) var interval     : String? = null,
    @SerializedName("rain"           ) var rain         : String? = null,
    @SerializedName("snowfall"       ) var snowfall     : String? = null,
    @SerializedName("cloud_cover"    ) var cloudCover   : String? = null,
    @SerializedName("wind_speed_10m" ) var windSpeed10m : String? = null

)
data class Current (

    @SerializedName("time"           ) var time         : String? = null,
    @SerializedName("interval"       ) var interval     : Int?    = null,
    @SerializedName("rain"           ) var rain         : Double? = null,
    @SerializedName("snowfall"       ) var snowfall     : Int?    = null,
    @SerializedName("cloud_cover"    ) var cloudCover   : Int?    = null,
    @SerializedName("wind_speed_10m" ) var windSpeed10m : Double? = null

)

fun getWeatherConditions(input: String): String {
    val weatherMap = mapOf(
        0 to "sunny",
        1 to "cloudy",
        2 to "rainy",
        3 to "windy",
        4 to "stormy"
    )

    val indices = input
        .removeSurrounding("[", "]")
        .split(",")
        .map { it.trim().toInt() }

    val conditions = indices.mapNotNull { weatherMap[it] }

    return conditions.joinToString(",")
}