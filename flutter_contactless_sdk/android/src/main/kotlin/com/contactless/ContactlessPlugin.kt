package com.contactless

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.nfc.NfcAdapter

/** ContactlessPlugin */
class ContactlessPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var nfcAdapter: NfcAdapter? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.contactless/sdk")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    nfcAdapter = NfcAdapter.getDefaultAdapter(context)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "initialize" -> {
        val apiKey = call.argument<String>("apiKey")
        val environment = call.argument<String>("environment")
        // Initialize security modules here
        result.success(true)
      }
      "isNfcAvailable" -> {
        result.success(nfcAdapter?.isEnabled ?: false)
      }
      "startPayment" -> {
        val amount = call.argument<Double>("amount")
        val currency = call.argument<String>("currency")
        
        // This would trigger the NFC session and EMV processing
        // For now, we return a mock success
        val mockResponse = mapOf(
          "success" to true,
          "transactionId" to "TXN_" + System.currentTimeMillis(),
          "authCode" to "123456",
          "maskedPan" to "4111********1111"
        )
        result.success(mockResponse)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
