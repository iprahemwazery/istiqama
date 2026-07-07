package apptest.istiqama

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "istiqama/notifications"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openNotificationSettings" -> {
                    openNotificationSettings()
                    result.success(true)
                }
                "openAppSettings" -> {
                    openAppSettings()
                    result.success(true)
                }
                "openBatteryOptimizationSettings" -> {
                    openBatteryOptimizationSettings()
                    result.success(true)
                }
                "startForegroundService" -> {
                    startForegroundService()
                    result.success(true)
                }
                "stopForegroundService" -> {
                    stopForegroundService()
                    result.success(true)
                }
                "testBackgroundNotification" -> {
                    val delay = (call.argument<Int>("delay") ?: 15000).toLong()
                    val title = call.argument<String>("title") ?: "\uD83D\uDD38\uFE0F اختبار الإشعار الخلفي"
                    val body = call.argument<String>("body") ?: "الإشعار شغال حتى لو التطبيق مقفول!"
                    testBackgroundNotification(delay, title, body)
                    result.success(true)
                }
                "schedulePrayerAlarms" -> {
                    @Suppress("UNCHECKED_CAST")
                    val prayerTimesRaw = call.argument<List<Long>>("prayerTimes")
                    val prayerNames = call.argument<List<String>>("prayerNames")?.toTypedArray()
                    if (prayerTimesRaw != null && prayerNames != null) {
                        val prayerTimes = prayerTimesRaw.toLongArray()
                        schedulePrayerAlarms(prayerTimes, prayerNames)
                    }
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startForegroundService() {
        val intent = Intent(this, PrayerForegroundService::class.java)
        startForegroundServiceCompat(intent)
    }

    private fun stopForegroundService() {
        val intent = Intent(this, PrayerForegroundService::class.java).apply {
            action = PrayerForegroundService.ACTION_STOP
        }
        startService(intent)
    }

    private fun testBackgroundNotification(delayMillis: Long, title: String, body: String) {
        val serviceIntent = Intent(this, PrayerForegroundService::class.java).apply {
            action = PrayerForegroundService.ACTION_TEST_BACKGROUND
            putExtra(PrayerForegroundService.EXTRA_DELAY_MILLIS, delayMillis)
            putExtra(PrayerForegroundService.EXTRA_TITLE, title)
            putExtra(PrayerForegroundService.EXTRA_BODY, body)
        }
        startForegroundServiceCompat(serviceIntent)
    }

    private fun schedulePrayerAlarms(prayerTimes: LongArray, prayerNames: Array<String>) {
        val serviceIntent = Intent(this, PrayerForegroundService::class.java).apply {
            action = PrayerForegroundService.ACTION_SCHEDULE_PRAYERS
            putExtra(PrayerForegroundService.EXTRA_PRAYER_TIMES, prayerTimes)
            putExtra(PrayerForegroundService.EXTRA_PRAYER_NAMES, prayerNames)
        }
        startForegroundServiceCompat(serviceIntent)
    }

    private fun startForegroundServiceCompat(intent: Intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun openNotificationSettings() {
        try {
            val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
                putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
            }
            startActivity(intent)
        } catch (e: Exception) {
            openAppSettings()
        }
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$packageName")
        }
        startActivity(intent)
    }

    private fun openBatteryOptimizationSettings() {
        try {
            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
            startActivity(intent)
        } catch (e: Exception) {
            openAppSettings()
        }
    }
}
