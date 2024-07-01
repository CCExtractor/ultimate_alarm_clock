package com.ccextractor.ultimate_alarm_clock

import android.util.Log
import com.android.volley.NetworkResponse
import com.android.volley.ParseError
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.HttpHeaderParser
import com.android.volley.toolbox.StringRequest
import com.google.gson.Gson

class GsonRequest<T>(
    url: String,
    private val clazz: Class<T>,
    private val listener: Response.Listener<T>,
    errorListener: Response.ErrorListener
) : Request<T>(Method.GET, url, errorListener) {

    private val gson = Gson()

    override fun parseNetworkResponse(response: NetworkResponse): Response<T> {
        return try {

            val json = String(response.data, charset(HttpHeaderParser.parseCharset(response.headers)))
            val parsedData = gson.fromJson(json, clazz)
            Response.success(parsedData, HttpHeaderParser.parseCacheHeaders(response))
        } catch (e: Exception) {
            Response.error(ParseError(e))
        }
    }

    override fun deliverResponse(response: T) {
        listener.onResponse(response)
    }

    override fun getHeaders(): Map<String, String> {
        val headers = HashMap<String, String>()
        headers["Content-Type"] = "application/json"
        return headers
    }
}



