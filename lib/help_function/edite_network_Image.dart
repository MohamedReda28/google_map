import 'package:http/http.dart' as http; // لا تنسى استيرادها
import "package:flutter/services.dart";

import 'dart:ui'as ui;
/// يحول صورة من رابط إنترنت (URL) إلى بيانات خام (Uint8List) بصيغة PNG بعد تصغيرها لعرض معين.
///
/// [imageUrl] : رابط الصورة على الإنترنت (مثلاً "https://example.com/logo.png")
/// [width] : العرض المرغوب (سيتم تقريبه لأقرب عدد صحيح)
///
/// يُرجع بيانات الصورة كـ Uint8List (بايتات PNG) بعد التحميل والتصغير.
///
/// ⚠️ ملاحظة: يجب أن يكون الرابط يُعيد ملف صورة (PNG/JPG/GIF...).
Future<Uint8List> getImageFromUrl(String imageUrl, double width) async {
  // 1. تحميل البيانات الخام للصورة من الإنترنت
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode != 200) {
    throw Exception('Failed to load image from URL: $imageUrl');
  }

  // 2. إنشاء كوديك لفك ضغط الصورة وتصغيرها للعرض المطلوب
  final imageCodec = await ui.instantiateImageCodec(
    response.bodyBytes, // البيانات الخام من الـ HTTP response
    targetWidth: width.round(),
  );

  // 3. استخراج أول إطار من الصورة
  final imageFrame = await imageCodec.getNextFrame();

  // 4. تحويل الإطار إلى بيانات PNG خام
  final imageByteData = await imageFrame.image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  // 5. إرجاع البيانات كـ Uint8List
  return imageByteData!.buffer.asUint8List();
}