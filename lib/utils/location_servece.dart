import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;

class LocationServece {
  Location location = Location();

  Future<bool> checkAndRequestLocationService() async {
    bool isServiceEnabled = false;

    // 1. التحقق مما إذا كانت خدمة الموقع مفعّلة
    isServiceEnabled = await location.serviceEnabled();

    if (!isServiceEnabled) {
      // 2. إذا كانت الخدمة غير مفعّلة، نطلب تفعيلها
      isServiceEnabled = await location.requestService();

      // 3. التحقق مما إذا نجح التفعيل أم لا
      if (!isServiceEnabled) {
        // 4. إذا فشل التفعيل (أي أن المستخدم رفض من الإعدادات أو حدث خطأ)، نعرض رسالة ونوجهه
        //await _showLocationServiceDisabledDialog(context);
        // نفتح إعدادات الجهاز مباشرة لتفعيل خدمة الموقع
        await perm_handler.openAppSettings();
        // نعيد التحقق مرة أخيرة بعد العودة من الإعدادات (ربما قام بتفعيلها)
        isServiceEnabled = await location.serviceEnabled();
      }
    }

    // 5. نعيد القيمة الحالية لحالة الخدمة (true أو false)
    return isServiceEnabled;
  }

  // دالة احترافية لطلب إذن الموقع مع معالجة جميع الحالات
  Future<bool> checkAndRequestPermissionLocation() async {
    bool isPermissionGranted = false;

    // 1. التحقق من الحالة الحالية للإذن
    var permissionStatus = await location.hasPermission();

    // 2. إذا كان مرفوضًا (ولم يكن مرفوض للأبد)
    if (permissionStatus == PermissionStatus.denied) {
      // نطلب الإذن من المستخدم
      permissionStatus = await location.requestPermission();

      // 3. نتحقق من نتيجة الطلب
      if (permissionStatus == PermissionStatus.granted) {
        // إذًا تم منح الإذن
        isPermissionGranted = true;
      } else if (permissionStatus == PermissionStatus.denied) {
        // تم الرفض مرة أخرى (وليس للأبد)، يمكننا عرض رسالة بسيطة
        isPermissionGranted = false;
      } else if (permissionStatus == PermissionStatus.deniedForever) {
        // تم الرفض للأبد، نعرض رسالة ونوجه لصفحة الإعدادات
        // نفتح إعدادات التطبيق مباشرة
        await perm_handler.openAppSettings();
        isPermissionGranted = false; // لأن الإذن لم يُمنح
      }
    } else if (permissionStatus == PermissionStatus.granted) {
      // إذن كان ممنوح من قبل
      isPermissionGranted = true;
    } else if (permissionStatus == PermissionStatus.deniedForever) {
      // الحالة التي تم فيها الرفض للأبد من قبل (ولم يتم طلب الإذن الآن)
      await perm_handler.openAppSettings();
      isPermissionGranted = false;
    }

    return isPermissionGranted;
  }


  void getRealTimeLocationData(void Function(LocationData)? onData){
    location.changeSettings(
      distanceFilter: 2,
    );
    location.onLocationChanged.listen(onData);
  }
}
