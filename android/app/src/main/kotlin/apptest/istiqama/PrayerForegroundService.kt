package apptest.istiqama

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import java.util.Calendar

class PrayerForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "prayer_service_channel"
        const val NOTIFICATION_ID = 1
        const val PRAYER_NOTIFICATION_ID_BASE = 100
        const val ACTION_STOP = "apptest.istiqama.STOP_FOREGROUND_SERVICE"
        const val ACTION_TEST_BACKGROUND = "apptest.istiqama.TEST_BACKGROUND_NOTIFICATION"
        const val ACTION_SCHEDULE_PRAYERS = "apptest.istiqama.SCHEDULE_PRAYERS"
        const val ACTION_PRAYER_ALARM = "apptest.istiqama.PRAYER_ALARM"
        const val EXTRA_DELAY_MILLIS = "delay_millis"
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"
        const val EXTRA_PRAYER_TIMES = "prayer_times"
        const val EXTRA_PRAYER_NAMES = "prayer_names"
        const val EXTRA_PRAYER_INDEX = "prayer_index"
    }

    private val handler = Handler(Looper.getMainLooper())
    private var delayedRunnable: Runnable? = null
    private var scheduledAlarmCount = 0

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> {
                cancelAllPrayerAlarms()
                stopForegroundService()
                return START_NOT_STICKY
            }
            ACTION_TEST_BACKGROUND -> {
                val delay = intent.getLongExtra(EXTRA_DELAY_MILLIS, 15000L)
                val title = intent.getStringExtra(EXTRA_TITLE) ?: "\uD83D\uDD38\uFE0F اختبار الإشعار الخلفي"
                val body = intent.getStringExtra(EXTRA_BODY) ?: "هذا الإشعار تم إطلاقه من الخدمة الخلفية"
                scheduleTestNotification(delay, title, body)
            }
            ACTION_SCHEDULE_PRAYERS -> {
                val prayerTimes = intent.getLongArrayExtra(EXTRA_PRAYER_TIMES)
                val prayerNames = intent.getStringArrayExtra(EXTRA_PRAYER_NAMES)
                if (prayerTimes != null && prayerNames != null) {
                    schedulePrayerAlarms(prayerTimes, prayerNames)
                }
            }
        }

        val notification = buildPersistentNotification()
        startForeground(NOTIFICATION_ID, notification)

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "خدمة مواقيت الصلاة",
            NotificationManager.IMPORTANCE_MIN
        ).apply {
            description = "إشعار دائم لتشغيل الخدمة الخلفية للصلاة"
            setShowBadge(false)
        }
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(channel)

        val prayerChannel = NotificationChannel(
            "prayer_times_channel",
            "مواقيت الصلاة",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "إشعارات مواقيت الصلاة"
            enableVibration(true)
            enableLights(true)
        }
        manager.createNotificationChannel(prayerChannel)
    }

    private fun buildPersistentNotification(): Notification {
        val stopIntent = Intent(this, PrayerForegroundService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 0, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val openIntent = packageManager.getLaunchIntentForPackage(packageName)
        val openPendingIntent = PendingIntent.getActivity(
            this, 1, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("تنبيهات مواقيت الصلاة نشطة")
            .setContentText("التطبيق يعمل في الخلفية لإرسال إشعارات الصلاة")
            .setSmallIcon(android.R.drawable.ic_popup_reminder)
            .setOngoing(true)
            .setContentIntent(openPendingIntent)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "إيقاف", stopPendingIntent)
            .build()
    }

    private fun schedulePrayerAlarms(prayerTimesMillis: LongArray, prayerNames: Array<String>) {
        cancelAllPrayerAlarms()
        scheduledAlarmCount = prayerTimesMillis.size

        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val now = System.currentTimeMillis()

        for (i in prayerTimesMillis.indices) {
            if (prayerTimesMillis[i] <= now) continue

            val intent = Intent(this, PrayerAlarmReceiver::class.java).apply {
                action = ACTION_PRAYER_ALARM
                putExtra(EXTRA_PRAYER_INDEX, i + PRAYER_NOTIFICATION_ID_BASE)
                putExtra(EXTRA_TITLE, "حان الآن موعد الأذان")
                putExtra(EXTRA_BODY, "حان الآن وقت صلاة ${prayerNames[i]} حسب توقيتك المحلي")
                putExtra(EXTRA_PRAYER_INDEX, i)
            }
            val pendingIntent = PendingIntent.getBroadcast(
                this, i + 100, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    prayerTimesMillis[i],
                    pendingIntent
                )
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    prayerTimesMillis[i],
                    pendingIntent
                )
            } else {
                alarmManager.set(
                    AlarmManager.RTC_WAKEUP,
                    prayerTimesMillis[i],
                    pendingIntent
                )
            }
        }
    }

    private fun cancelAllPrayerAlarms() {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        for (i in 0 until scheduledAlarmCount) {
            val intent = Intent(this, PrayerAlarmReceiver::class.java).apply {
                action = ACTION_PRAYER_ALARM
            }
            val pendingIntent = PendingIntent.getBroadcast(
                this, i + 100, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_NO_CREATE
            )
            pendingIntent?.let {
                alarmManager.cancel(it)
                it.cancel()
            }
        }
        scheduledAlarmCount = 0
    }

    private fun scheduleTestNotification(delayMillis: Long, title: String, body: String) {
        delayedRunnable?.let { handler.removeCallbacks(it) }

        delayedRunnable = Runnable {
            wakeUpAndNotify(title, body)
        }

        handler.postDelayed(delayedRunnable!!, delayMillis)
    }

    private fun wakeUpAndNotify(title: String, body: String) {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = pm.newWakeLock(
            PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "istiqama:notification_wake"
        )
        wakeLock.acquire(5000L)

        showNotification(title, body)

        wakeLock.release()
    }

    private fun showNotification(title: String, body: String) {
        val openIntent = packageManager.getLaunchIntentForPackage(packageName)
        val openPendingIntent = PendingIntent.getActivity(
            this, PRAYER_NOTIFICATION_ID_BASE, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, "prayer_times_channel")
            .setSmallIcon(android.R.drawable.ic_popup_reminder)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setFullScreenIntent(openPendingIntent, true)
            .setAutoCancel(true)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .build()

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(PRAYER_NOTIFICATION_ID_BASE, notification)
    }

    private fun stopForegroundService() {
        delayedRunnable?.let { handler.removeCallbacks(it) }
        delayedRunnable = null
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    override fun onDestroy() {
        delayedRunnable?.let { handler.removeCallbacks(it) }
        delayedRunnable = null
        super.onDestroy()
    }
}

class PrayerAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra(PrayerForegroundService.EXTRA_TITLE) ?: "حان الآن موعد الأذان"
        val body = intent.getStringExtra(PrayerForegroundService.EXTRA_BODY) ?: "حان الآن وقت الصلاة"

        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = pm.newWakeLock(
            PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "istiqama:prayer_alarm_wake"
        )
        wakeLock.acquire(5000L)

        val openIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val openPendingIntent = PendingIntent.getActivity(
            context, 0, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, "prayer_times_channel")
            .setSmallIcon(android.R.drawable.ic_popup_reminder)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setFullScreenIntent(openPendingIntent, true)
            .setAutoCancel(true)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .build()

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(
            intent.getIntExtra(PrayerForegroundService.EXTRA_PRAYER_INDEX, 0) + PrayerForegroundService.PRAYER_NOTIFICATION_ID_BASE,
            notification
        )

        wakeLock.release()
    }
}
