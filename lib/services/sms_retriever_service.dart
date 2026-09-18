import 'dart:developer';
import 'package:flutter/services.dart';

/// Escuta o SMS de verificação através de um canal nativo.
///
/// Requer a implementação nativa correspondente em Android
/// (SMS Retriever API) registada no mesmo [MethodChannel].
/// Ajusta [_channel] para o `applicationId` do novo projeto.
class SmsRetrieverService {
  static const _channel = MethodChannel('com.example.app/sms_retriever');

  static Future<String?> startSmsRetrieval() async {
    try {
      log('[SmsRetrieverService] a iniciar escuta de SMS', name: 'SmsRetrieverService');
      final sms = await _channel.invokeMethod<String>('startSmsRetrieval');
      log('[SmsRetrieverService] SMS recebido', name: 'SmsRetrieverService');
      return sms;
    } on PlatformException catch (e) {
      log('[SmsRetrieverService] erro: ${e.code} - ${e.message}', name: 'SmsRetrieverService');
      return null;
    }
  }

  static Future<void> stopSmsRetrieval() async {
    try {
      await _channel.invokeMethod<void>('stopSmsRetrieval');
    } on PlatformException catch (e) {
      log('[SmsRetrieverService] erro ao parar: ${e.code}', name: 'SmsRetrieverService');
    }
  }
}
