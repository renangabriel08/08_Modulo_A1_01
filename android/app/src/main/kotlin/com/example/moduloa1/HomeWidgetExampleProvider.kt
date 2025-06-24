package com.example.moduloa1

import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.appwidget.AppWidgetManager
import android.net.Uri
import android.widget.RemoteViews

class HomeWidgetExampleProvider : HomeWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
            widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.example_layout).apply {
                val count = widgetData.getInt("counter", 0)
                setTextViewText(R.id.text, "Estou com saudades, volte aqui vamos jogar e aprender!.")

                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("homeWidgetExample://message?message=olamundo"))
            setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
