import 'services/settings_service.dart';

class T {
  T(this.language);
  final AppLanguage language;

  bool get ar => language == AppLanguage.arabic;

  String get appName => 'Scanova QR';
  String get tagline => ar ? 'ماسح QR سريع وآمن' : 'Fast & private QR scanner';
  String get scanQr => ar ? 'مسح QR' : 'Scan QR';
  String get history => ar ? 'السجل' : 'History';
  String get settings => ar ? 'الإعدادات' : 'Settings';
  String get recentScans => ar ? 'آخر عمليات المسح' : 'Recent scans';
  String get noScans => ar ? 'لا توجد عمليات مسح بعد' : 'No scans yet';
  String get startScanning => ar ? 'ابدأ بمسح رمز QR ليظهر هنا.' : 'Scan a QR code to see it here.';
  String get scanner => ar ? 'ماسح QR' : 'QR Scanner';
  String get pointCamera => ar ? 'وجّه الكاميرا نحو رمز QR' : 'Point the camera at a QR code';
  String get gallery => ar ? 'المعرض' : 'Gallery';
  String get flash => ar ? 'الفلاش' : 'Flash';
  String get result => ar ? 'النتيجة' : 'Result';
  String get content => ar ? 'المحتوى' : 'Content';
  String get copy => ar ? 'نسخ' : 'Copy';
  String get share => ar ? 'مشاركة' : 'Share';
  String get open => ar ? 'فتح' : 'Open';
  String get scanAgain => ar ? 'مسح مرة أخرى' : 'Scan again';
  String get save => ar ? 'حفظ في السجل' : 'Save to history';
  String get saved => ar ? 'تم الحفظ' : 'Saved';
  String get clearAll => ar ? 'مسح الكل' : 'Clear all';
  String get delete => ar ? 'حذف' : 'Delete';
  String get cancel => ar ? 'إلغاء' : 'Cancel';
  String get confirm => ar ? 'تأكيد' : 'Confirm';
  String get clearHistoryQuestion => ar ? 'حذف كل السجل؟' : 'Clear all history?';
  String get clearHistoryBody => ar ? 'لا يمكن التراجع عن هذا الإجراء.' : 'This action cannot be undone.';
  String get appearance => ar ? 'المظهر' : 'Appearance';
  String get theme => ar ? 'السمة' : 'Theme';
  String get system => ar ? 'النظام' : 'System';
  String get light => ar ? 'فاتح' : 'Light';
  String get dark => ar ? 'داكن' : 'Dark';
  String get language => ar ? 'اللغة' : 'Language';
  String get english => 'English';
  String get arabic => 'العربية';
  String get haptics => ar ? 'الاهتزاز' : 'Haptic feedback';
  String get hapticsSubtitle => ar ? 'اهتزاز قصير عند نجاح المسح' : 'Short vibration after a successful scan';
  String get about => ar ? 'حول التطبيق' : 'About';
  String get privacy => ar ? 'الخصوصية' : 'Privacy';
  String get privacyBody => ar ? 'يعمل Scanova QR محليًا ولا يرسل نتائج المسح إلى خوادم خارجية.' : 'Scanova QR works locally and does not send scan results to external servers.';
  String get version => ar ? 'الإصدار' : 'Version';
  String get cameraDenied => ar ? 'تم رفض إذن الكاميرا. فعّل الإذن من إعدادات النظام.' : 'Camera permission was denied. Enable it in system settings.';
  String get cameraUnavailable => ar ? 'لا توجد كاميرا متاحة على هذا الجهاز.' : 'No camera is available on this device.';
  String get scanError => ar ? 'تعذر تشغيل الكاميرا.' : 'Unable to start the camera.';
  String get noQrFound => ar ? 'لم يتم العثور على QR في الصورة.' : 'No QR code was found in the image.';
  String get invalidQr => ar ? 'تعذر قراءة هذا الرمز.' : 'This code could not be read.';
  String get copied => ar ? 'تم نسخ المحتوى' : 'Content copied';
  String get opened => ar ? 'تم فتح الرابط' : 'Link opened';
  String get type => ar ? 'النوع' : 'Type';
  String get scanFromGallery => ar ? 'مسح من صورة' : 'Scan from image';
  String get close => ar ? 'إغلاق' : 'Close';
}
