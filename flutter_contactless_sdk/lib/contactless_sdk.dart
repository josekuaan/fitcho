import 'dart:async';
import 'package:flutter/services.dart';
import 'src/models/payment_request.dart';
import 'src/models/payment_result.dart';
import 'src/models/card_data.dart';
import 'src/nfc/emv_card_reader.dart';

export 'src/models/payment_request.dart';
export 'src/models/payment_result.dart';
export 'src/models/card_data.dart';

class ContactlessSDK {
  static const MethodChannel _channel = MethodChannel('com.contactless/sdk');
  static final EmvCardReader _cardReader = EmvCardReader();

  /// Start a payment session
  static Future<PaymentResult> startPayment(PaymentRequest request) async {
    try {
      final Map<String, dynamic>? result = await _channel.invokeMapMethod<String, dynamic>(
        'startPayment',
        request.toJson(),
      );

      if (result == null) {
        return PaymentResult.failure(errorMessage: 'Internal SDK Error: No response received');
      }

      return PaymentResult(
        success: result['success'] ?? false,
        transactionId: result['transactionId'],
        authCode: result['authCode'],
        maskedPan: result['maskedPan'],
        errorMessage: result['errorMessage'],
        errorCode: result['errorCode'],
      );
    } catch (e) {
      return PaymentResult.failure(errorMessage: e.toString());
    }
  }

  /// Start scanning for an EMV card and return its details
  /// [onStatusUpdate] provides progress updates like "Reading...", "Hold your card...", etc.
  static Future<CardData?> readCardDetails({Function(String)? onStatusUpdate}) async {
    return _cardReader.readCard(onStatusUpdate: onStatusUpdate);
  }

  /// Initialize the SDK with security keys
  static Future<bool> initialize({required String apiKey, String? environment}) async {
    try {
      final bool? success = await _channel.invokeMethod<bool>('initialize', {
        'apiKey': apiKey,
        'environment': environment ?? 'sandbox',
      });
      return success ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if NFC is available on this device
  static Future<bool> isNfcAvailable() async {
    try {
      final bool? available = await _channel.invokeMethod<bool>('isNfcAvailable');
      return available ?? false;
    } catch (e) {
      return false;
    }
  }
}

