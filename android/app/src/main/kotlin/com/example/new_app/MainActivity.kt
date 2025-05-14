package com.example.new_app

import android.media.RingtoneManager
import android.media.Ringtone
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.dialer"
    private var ringtone: Ringtone? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openDialer" -> {
                    val number = call.argument<String>("number")
                    val intent = Intent(Intent.ACTION_DIAL)
                    intent.data = Uri.parse("tel:$number")
                    startActivity(intent)
                    result.success("Dialer opened")
                }

                "playRingtone" -> {
                    val notification: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
                    ringtone = RingtoneManager.getRingtone(applicationContext, notification)
                    ringtone?.play()
                    result.success("Android ringtone playing")
                }

                "stopRingtone" -> {
                    ringtone?.stop()
                    result.success("Android ringtone stopped")
                }

                else -> result.notImplemented()
            }
        }
    }
}
