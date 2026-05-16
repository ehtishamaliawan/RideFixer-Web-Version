package com.example.ride_care

import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.os.Build
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "ridefixer/foreground"
	private val NOISE_CHANNEL = "ridefixer/noise_preview"
	private var previewPlayer: MediaPlayer? = null

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"start" -> {
					val bikeId = (call.argument<Int>("bikeId") ?: 0)
					val intent = Intent(this, ForegroundLocationService::class.java).apply {
						action = ForegroundLocationService.ACTION_START
						putExtra(ForegroundLocationService.EXTRA_BIKE_ID, bikeId)
					}
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
						ContextCompat.startForegroundService(this, intent)
					} else {
						startService(intent)
					}
					result.success(true)
				}
				"stop" -> {
					val intent = Intent(this, ForegroundLocationService::class.java).apply {
						action = ForegroundLocationService.ACTION_STOP
					}
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
						ContextCompat.startForegroundService(this, intent)
					} else {
						startService(intent)
					}
					result.success(true)
				}
				// Returns live data from the native foreground service so Flutter can
				// read distance/state without SharedPreferences namespace issues.
				"getStatus" -> {
					val prefs = getSharedPreferences("ridefixer", Context.MODE_PRIVATE)
					result.success(hashMapOf<String, Any>(
						"fg_running"          to prefs.getBoolean("fg_running", false),
						"fg_meters"           to prefs.getFloat("fg_meters", 0f).toDouble(),
						"fg_unsaved"          to prefs.getBoolean("fg_unsaved", false),
						"fg_unsaved_bikeId"   to prefs.getInt("fg_unsaved_bikeId", 0),
						"fg_unsaved_meters"   to prefs.getFloat("fg_unsaved_meters", 0f).toDouble()
					))
				}
				// Called after Flutter consumes or discards an unsaved ride entry.
				"clearUnsaved" -> {
					val prefs = getSharedPreferences("ridefixer", Context.MODE_PRIVATE)
					prefs.edit()
						.remove("fg_unsaved")
						.remove("fg_unsaved_bikeId")
						.remove("fg_unsaved_meters")
						.remove("fg_unsaved_end_ms")
						.remove("fg_meters")
						.apply()
					result.success(true)
				}
				else -> result.notImplemented()
			}
		}

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOISE_CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"playPreview" -> {
					val type = call.argument<String>("type") ?: ""
					val resId = when (type) {
						"motor_gears" -> R.raw.motor_gears_finish_noise
						"derailleur_adjustment" -> R.raw.derailleur_adjustment_noise
						"spokes_loose" -> R.raw.spoke_loose_noise
						"touching_disk" -> R.raw.touching_disk_noise
						else -> 0
					}

					if (resId == 0) {
						result.error("invalid_type", "Unknown preview type: $type", null)
						return@setMethodCallHandler
					}

					try {
						previewPlayer?.stop()
						previewPlayer?.release()
						previewPlayer = MediaPlayer.create(this, resId)
						previewPlayer?.setOnCompletionListener {
							it.release()
							previewPlayer = null
						}
						previewPlayer?.start()
						result.success(true)
					} catch (e: Exception) {
						previewPlayer?.release()
						previewPlayer = null
						result.error("playback_failed", e.message, null)
					}
				}
				"stopPreview" -> {
					try {
						previewPlayer?.stop()
					} catch (_: Exception) {
					}
					previewPlayer?.release()
					previewPlayer = null
					result.success(true)
				}
				else -> result.notImplemented()
			}
		}
	}

	override fun onDestroy() {
		previewPlayer?.release()
		previewPlayer = null
		super.onDestroy()
	}
}
