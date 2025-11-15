



import "package:flutter/services.dart";

import 'dart:ui'as ui;

/// يحول صورة من assets إلى بيانات خام (Uint8List) بصيغة PNG بعد تصغيرها لعرض معين.
///
/// [image] : مسار الصورة في assets (مثلاً "assets/images/logo.png")
/// [width] : العرض المرغوب (سيتم تقريبه لأقرب عدد صحيح)
///
/// يُرجع بيانات الصورة كـ Uint8List (بايتات PNG) بعد التحميل والتصغير.
///
/// ⚠️ ملاحظة: هذه الدالة فقط تنفع للصور داخل المشروع (assets)، مش للصور من الإنترنت.
Future<Uint8List> getImageFromRawData(String image, double width) async {
  // 1. تحميل البيانات الخام للصورة من assets
  final imageData = await rootBundle.load(image);

  // 2. إنشاء كوديك لفك ضغط الصورة وتصغيرها للعرض المطلوب
  final imageCodec = await ui.instantiateImageCodec(
    imageData.buffer.asUint8List(),
    targetWidth: width.round(), // تحويل العرض لعدد صحيح
  );

  // 3. استخراج أول إطار من الصورة (لأن معظم الصور لها إطار واحد)
  final imageFrame = await imageCodec.getNextFrame();

  // 4. تحويل الإطار إلى بيانات PNG خام
  final imageByteData = await imageFrame.image.toByteData(
    format: ui.ImageByteFormat.png, // يمكن تغييرها لـ jpeg إذا أردت
  );

  // 5. إرجاع البيانات كـ Uint8List (مصفوفة بايتات)
  return imageByteData!.buffer.asUint8List();
}