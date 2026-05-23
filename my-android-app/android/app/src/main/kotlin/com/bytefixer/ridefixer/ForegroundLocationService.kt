package com.example.ride_care

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import android.content.SharedPreferences

class ForegroundLocationService : Service() {
    companion object {
        const val ACTION_START = "com.example.ride_care.action.START"
        const val ACTION_STOP = "com.example.ride_care.action.STOP"
        const val EXTRA_BIKE_ID = "bikeId"
        // Match Flutter side tracking notification so updates/restarts replace the same entry
        const val CHANNEL_ID = "ride_tracking_channel"
        const val NOTIF_ID = 10002
    }

    private lateinit var fusedClient: FusedLocationProviderClient
    private var lastLocation: Location? = null
    private var meters = 0f
    private var bikeId = 0
    private lateinit var prefs: SharedPreferences
    private var lastNotifMs: Long = 0
    // True when Flutter explicitly called stop (ride already saved by Flutter).
    // Prevents markUnsavedRide() from double-counting in onDestroy().
    private var cleanStop = false

    private val locationCallback = object : LocationCallback() {
        override fun onLocationResult(result: LocationResult) {
            val loc = result.lastLocation ?: return

            // --- accuracy filter ---
            // Indoor GPS can report 10-18 m accuracy while still drifting.
            // Only accept fixes with accuracy <= 10 m.
            if (loc.hasAccuracy() && loc.accuracy > 10f) {
                lastLocation = null
                return
            }

            // --- speed from sensor ---
            // Android fuses accelerometer data into Location.speed; if the phone
            // reports < 0.8 m/s (~3 km/h) the user is not on a moving bike.
            if (loc.hasSpeed() && loc.speed < 0.8f) {
                lastLocation = loc
                return
            }

            if (lastLocation != null) {
                val delta = lastLocation!!.distanceTo(loc)
                val timeDeltaSec = (loc.time - lastLocation!!.time) / 1000.0
                val impliedSpeed = if (timeDeltaSec > 0) delta / timeDeltaSec else 0.0

                // delta >= 5 m AND speed looks reasonable (< 20 m/s = 72 km/h)
                if (delta >= 5f && impliedSpeed < 20.0) {
                    meters += delta
                    prefs.edit().putFloat("fg_meters", meters).apply()
                }
            }
            lastLocation = loc
            updateNotificationThrottled()
        }
    }

    override fun onCreate() {
        super.onCreate()
        fusedClient = LocationServices.getFusedLocationProviderClient(this)
        prefs = getSharedPreferences("ridefixer", Context.MODE_PRIVATE)
        createChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        if (action == ACTION_STOP) {
            // Flutter already saved the ride distance — do NOT mark unsaved here.
            cleanStop = true
            prefs.edit().putBoolean("fg_running", false).apply()
            stopForeground(true)
            stopSelf()
            return START_NOT_STICKY
        }

        bikeId = intent?.getIntExtra(EXTRA_BIKE_ID, 0) ?: 0
        meters = 0f
        prefs.edit().putFloat("fg_meters", 0f).apply()
        prefs.edit()
            .putInt("fg_bikeId", bikeId)
            .putBoolean("fg_running", true)
            .apply()

        val notification = buildNotification()
        startForeground(NOTIF_ID, notification)
        startLocationUpdates()

        return START_STICKY
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val nm = getSystemService(NotificationManager::class.java)
            val chan = NotificationChannel(CHANNEL_ID, "Ride Tracking", NotificationManager.IMPORTANCE_LOW)
            nm.createNotificationChannel(chan)
        }
    }

    private fun buildNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pending = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val km = (meters / 1000f)
        val title = "Ride tracking active"
        val text = String.format("%.2f km", km)
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentIntent(pending)
            .setOngoing(true)
            .build()
    }

    private fun updateNotification() {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        nm.notify(NOTIF_ID, buildNotification())
    }

    private fun updateNotificationThrottled() {
        val now = System.currentTimeMillis()
        if (now - lastNotifMs < 30_000L) return
        lastNotifMs = now
        updateNotification()
    }

    private fun startLocationUpdates() {
        val req = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 10_000L).apply {
            setMinUpdateDistanceMeters(10.0f)
        }.build()
        try {
            fusedClient.requestLocationUpdates(req, locationCallback, Looper.getMainLooper())
        } catch (e: SecurityException) {
            // permission missing
        }
    }

    private fun stopLocationUpdates() {
        fusedClient.removeLocationUpdates(locationCallback)
    }

    override fun onDestroy() {
        stopLocationUpdates()
        // Only mark unsaved when the OS killed the service unexpectedly.
        // If Flutter called stop explicitly (cleanStop=true) it already saved the distance.
        if (!cleanStop) markUnsavedRide()
        prefs.edit().remove("fg_bikeId").putBoolean("fg_running", false).apply()
        super.onDestroy()
    }

    private fun markUnsavedRide() {
        try {
            val currentMeters = prefs.getFloat("fg_meters", meters)
            if (currentMeters > 1f && bikeId > 0) {
                prefs.edit()
                    .putBoolean("fg_unsaved", true)
                    .putInt("fg_unsaved_bikeId", bikeId)
                    .putFloat("fg_unsaved_meters", currentMeters)
                    .putLong("fg_unsaved_end_ms", System.currentTimeMillis())
                    .apply()
            }
        } catch (_: Exception) {
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
